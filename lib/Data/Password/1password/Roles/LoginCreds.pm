package Data::Password::1password::Roles::LoginCreds;

use Moose::Role;

use JSON::Any;
use List::Util 'first';

has '_cached_data' =>
    ( isa => 'HashRef', is => 'ro', lazy => 1, builder => '_get_data' );

sub _get_data {
    my $self = shift;
    return $self->decrypted_data;
}

sub username {
    my $self = shift;
    return ( first { $_->{name} =~ m/user/i }
        @{ $self->_cached_data->{fields} } )->{value};
}

sub password {
    my $self = shift;
    return ( first { $_->{name} =~ m/pass/i }
        @{ $self->_cached_data->{fields} } )->{value};

}

1;
