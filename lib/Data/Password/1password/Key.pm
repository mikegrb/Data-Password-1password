package Data::Password::1password::Key;

use Moose;
use namespace::autoclean;

use Data::Dumper;
use Crypt::PBKDF2;
use MIME::Base64;
use Data::Password::1password::Types;

use bytes;

# TODO: should probably use unpack instead of use bytes and substr etc

with 'Data::Password::1password::Roles::json';

has 'identifier'  => ( isa => 'Str', is => 'ro' );
has 'level'       => ( isa => 'Str', is => 'ro' );
has 'data'        => ( isa => 'Str', is => 'ro' );
has 'validation'  => ( isa => 'Str', is => 'ro' );
has 'master_pass' => ( isa => 'Str', is => 'ro' );

has 'encrypted_key' => (
    isa     => 'Str',
    is      => 'ro',
    lazy    => 1,
    builder => sub { decode_base64( $_[0]->data ) } );

has 'salt' => ( isa => 'Str', is => 'ro', lazy => 1, builder => '_get_salt' );

has 'intermediate_key' => (
    isa     => 'HashRef',
    is      => 'ro',
    lazy    => 1,
    builder => '_get_intermediate_key'
);

sub _get_salt {

    my $self = shift;

    my $key = $self->encrypted_key;
    return "\x00" x 16 unless substr( $key, 0, 8 ) eq 'Salted__';

    $self->meta->get_attribute('encrypted_key')
        ->set_value( substr( $key, 16 ) );
    return substr $key, 8, 16;
}

sub _get_intermediate_key {
    my $self       = shift;
    my $pbkdf2     = Crypt::PBKDF2->new( outlen => 32, iterations => 1000 );
    my $key_and_iv = $pbkdf2->PBKDF2( $self->salt, $self->master_pass );

    my $key = substr( $key_and_iv, 0, 16 );
    my $iv = substr( $key_and_iv, 16 );

    return { key => $key, iv => $iv };
}

1;

