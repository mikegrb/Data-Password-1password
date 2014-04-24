package Data::Password::1password::Key;

use Moose;
use namespace::autoclean;

use Data::Dumper;
use Crypt::CBC;
use MIME::Base64;
use Crypt::PBKDF2;
use Crypt::Digest::MD5 'md5';
use Crypt::Cipher::AES;
use Data::Password::1password::Types;

use bytes;

# TODO: should probably use unpack instead of use bytes and substr etc

with 'Data::Password::1password::Roles::json';

# from encryptionKeys.js
has 'identifier' => ( isa => 'Str', is => 'ro' );
has 'level'      => ( isa => 'Str', is => 'ro' );
has 'data'       => ( isa => 'Str', is => 'ro' );
has 'validation' => ( isa => 'Str', is => 'ro' );

# end attributs from encryptionKeys.js

has 'key' => ( isa => 'Str', is => 'ro', lazy => 1, builder => '_decrypt_key' );

has 'root' => (
    is       => 'ro',
    isa      => 'Data::Password::1password',
    weak_ref => 1,
    reader   => '_root'
);

sub _decrypt_key {
    my $self = shift;

    my ( $salt, $decrypt_key ) = _salt_from_b64( $self->data );

    my $pbkdf2 = Crypt::PBKDF2->new( outlen => 32, iterations => 1000 );

    my ( $key, $iv )
        = _split_key_and_iv(
        $pbkdf2->PBKDF2( $salt, $self->_root->master_key ) );

    return _aes_decrypt( $key, $iv, $decrypt_key );
}

sub decrypt {
    my ( $self, $encrypted, $b64 ) = @_;

    my ( $salt, $data )
        = $b64 ? _salt_from_b64($encrypted) : _salt_from_string($encrypted);
    my ( $key, $iv ) = _derive_md5( $self->key, $salt );
    return aes_decrypt( $key, $iv, $data );
}

sub _aes_decrypt {
    my ( $key, $iv, $data ) = @_;
    my $cbc
        = Crypt::CBC->new( -cipher => 'Cipher::AES', -key => $key, -iv => $iv );
    return _strip_padding( $cbc->decrypt($data) );
}

sub _strip_padding {
    my $string = shift;
    my $padding_size = ord( substr( $string, -1 ) );
    return $string if $padding_size >= 16;
    return substr( $string, -1 * $padding_size );
}

sub _salt_from_string {
    my $string = shift;

    return "\x00" x 16 unless substr( $string, 0, 8 ) eq 'Salted__';

    my $salt = substr( $string, 8, 16 );
    my $data = substr( $string, 16 );

    return $salt, $data;
}

sub _salt_from_b64 {
    my $data = shift;
    return _salt_from_string( decode_base64($data) );
}

sub _derive_md5 {
    my ( $key, $salt ) = @_;
    $key = substr $key, 0, -16;
    my ( $key_and_iv, $prev );
    while ( length($key_and_iv) < 32 ) {
        $prev = md5( $prev . $key . $salt );
        $key_and_iv .= $prev;
    }
    return _split_key_and_iv($key_and_iv);
}

sub _split_key_and_iv {
    my $key_and_iv = shift;
    my $key        = substr( $key_and_iv, 0, 16 );
    my $iv         = substr( $key_and_iv, 16 );
    return ( $key, $iv );
}

1;
