package Data::Password::1password::Roles::PasswordField;

use Moose::Role;

use JSON::Any;
use List::Util 'first';

sub password {
    my $self = shift;

    my $key  = $self->root->keys->get_key( $self->keyID );
    my $data = JSON::Any->jsonToObj( $key->decrypt( $self->encrypted ) );

    my $password_field
        = first { $_->{name} eq 'password' } @{ $data->{fields} };

    return unless $password_field;
    return $password_field->{value};
}

1;
