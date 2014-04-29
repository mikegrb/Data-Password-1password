package Data::Password::1password::Roles::PasswordField;

use Moose::Role;
use JSON::Any;
use List::Util 'first';

sub password {
    my $self = shift;

    my $encrypted_data
        = $self->root->keys->key_for_level( $self->securityLevel )
        ->decrypt( $self->encrypted );
    $encrypted_data = JSON::Any->jsonToObj($encrypted_data);

    my $password_field
        = first { $_->{name} eq 'password' } @{ $encrypted_data->{fields} };

    return unless $password_field;
    return $password_field->{value};
}

1;
