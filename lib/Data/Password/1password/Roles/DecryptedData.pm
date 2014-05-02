package Data::Password::1password::Roles::DecryptedData;

use Moose::Role;

use JSON::Any;


sub decrypted_data {
    my $self = shift;

    my $key  = $self->root->keys->get_key( $self->keyID );
    return JSON::Any->jsonToObj( $key->decrypt( $self->encrypted ) );
}

1;
