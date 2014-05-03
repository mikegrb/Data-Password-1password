package Data::Password::1password::Roles::DecryptedData;

use Moose::Role;

use JSON::Any;

has 'decrypted_data' =>
    ( isa => 'HashRef', is => 'ro', lazy => 1, builder => '_decrypt_data' );

sub _decrypt_data {
    my $self = shift;
    my $key
        = $self->keyID
        ? $self->root->keys->get_key( $self->keyID )
        : $self->root->keys->key_for_level( $self->securityLevel );
    return JSON::Any->jsonToObj( $key->decrypt( $self->encrypted ) );
}

1;
