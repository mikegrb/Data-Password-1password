package Data::Password::1password::Key;

use Moose;
use namespace::autoclean;

use Data::Dumper;
use MIME::Base64;
use Data::Password::1password::Types;

with 'Data::Password::1password::Roles::json';

has 'identifier' => ( isa => 'Str', is => 'ro' );
has 'level'      => ( isa => 'Str', is => 'ro' );
has 'data'       => ( isa => 'Str', is => 'ro' );
has 'validation' => ( isa => 'Str', is => 'ro' );
has 'master_key' => ( isa => 'Str', is => 'ro' );

has 'encrypted_key' => (
    isa     => 'Str',
    is      => 'ro',
    lazy    => 1,
    builder => sub { decode_base64( $_[0]->data ) } );

has 'salt' => ( isa => 'Str', is => 'ro', lazy => 1, builder => '_get_salt' );
has 'iv' => ( isa => 'Str', is => 'ro' );;

sub _get_salt {
    use bytes;
    # TODO: should probably use unpack instead of use bytes and substr etc

    my $self = shift;

    my $key = $self->encrypted_key;
    return "\x00" x 16 unless substr( $key, 0, 8 ) eq 'Salted__';

    $self->meta->get_attribute('encrypted_key')
        ->set_value( substr( $key, 16 ) );
    return substr $key, 8, 16;
}

1;

