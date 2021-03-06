package Data::Password::1password::Key;

use Moose;
use namespace::autoclean;

use Data::Dumper;
use Data::HexDump;
use MIME::Base64;
use Crypt::KeyDerivation 'pbkdf2';
use Crypt::Digest::MD5 'md5';
use Crypt::Cipher::AES;
use Crypt::Mode::CBC;
use Data::Password::1password::Types;

use bytes;

# TODO: should probably use unpack instead of use bytes and substr etc

with 'Data::Password::1password::Roles::json';

# from encryptionKeys.js
has 'identifier' => ( isa => 'Str', is => 'ro' );
has 'level'      => ( isa => 'Str', is => 'ro' );
has 'data'       => ( isa => 'Str', is => 'ro' );
has 'validation' => ( isa => 'Str', is => 'ro' );
has 'iterations' =>
    ( isa => 'Int', is => 'ro', default => sub { return 1000 } );
# end attributs from encryptionKeys.js

has '_decrypted_key' => ( isa => 'Str', is => 'ro', lazy => 1, builder => '_decrypt_key' );

has 'root' => (
    is       => 'ro',
    isa      => 'Data::Password::1password',
    weak_ref => 1,
    reader   => '_root'
);

sub _decrypt_key {
    my $self = shift;
    my ( $salt, $decrypt_key ) = _salt_from_b64( $self->data );
    my ( $key, $iv )
        = _split_key_and_iv(
        pbkdf2( $self->_root->master_pass, $salt, $self->iterations, 'SHA1' ) );
    my $decrypted_key = _aes_decrypt( $key, $iv, $decrypt_key );

    die "Bad passphrase!"
        unless $decrypted_key eq
        _decrypt( $self->validation, $decrypted_key );
    return $decrypted_key;
}

sub decrypt {
    my ( $self, $encrypted ) = @_;
    return _decrypt( $encrypted, $self->_decrypted_key );
}

sub _decrypt {
    my ( $encrypted, $decryption_key ) = @_;
    my ( $salt,      $data )           = _salt_from_b64($encrypted);
    my ( $key, $iv ) = _derive_md5( $decryption_key, $salt );
    return _aes_decrypt( $key, $iv, $data );
}

sub _aes_decrypt {
    my ( $key, $iv, $data ) = @_;
    my $m = Crypt::Mode::CBC->new('AES');
    return $m->decrypt( $data, $key, $iv );
}

sub _salt_from_string {
    my $string = shift;

    die "data malformed?!" unless substr( $string, 0, 8 ) eq 'Salted__';

    my $salt = substr( $string, 8, 8 );
    my $data = substr( $string, 16 );

    return ($salt, $data);
}

sub _salt_from_b64 {
    my $data = shift;
    return _salt_from_string( decode_base64($data) );
}

sub _derive_md5 {
    my ( $key, $salt ) = @_;

    my ( $key_and_iv, $prev ) = ('', '');
    while ( length($key_and_iv) < 32 ) {
        $prev = md5( $prev . $key . $salt );
        $key_and_iv .= $prev;
    }
    return _split_key_and_iv($key_and_iv);
}

sub _split_key_and_iv {
    my $key_and_iv = shift;
    my ($key, $iv) = unpack('(a16)2', $key_and_iv);
    return ( $key, $iv );
}

1;
