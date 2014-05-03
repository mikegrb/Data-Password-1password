package Data::Password::1password::Roles::LoginCreds;

use Moose::Role;

use JSON::Any;
use List::Util 'first';

sub username {
    my $self = shift;
    return ( first { $_->{name} =~ m/user/i }
        @{ $self->decrypted_data->{fields} } )->{value};
}

sub password {
    my $self = shift;
    return ( first { $_->{name} =~ m/pass/i }
        @{ $self->decrypted_data->{fields} } )->{value};

}

1;
