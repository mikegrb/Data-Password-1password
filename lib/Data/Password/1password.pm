package Data::Password::1password;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;
use Data::Password::1password::Contents;
use Data::Password::1password::Keys;

has 'path' => ( isa => 'ExistingPath', is => 'ro' );

has 'master_key' => ( isa => 'Str', is => 'ro', required => 1 );

has 'contents' => (
    isa     => 'Data::Password::1password::Contents',
    is      => 'ro',
    lazy    => 1,
    builder => '_build_contents'
);
has 'keys' => (
    isa     => 'Data::Password::1password::Keys',
    is      => 'ro',
    lazy    => 1,
    builder => '_build_keys'
);

sub _build_contents {
    my $self = shift;
    return Data::Password::1password::Contents->new( path => $self->path );
}

sub _build_keys {
    my $self = shift;
    return Data::Password::1password::Keys->new(
        path => $self->path,
        root => $self
    );
}

__PACKAGE__->meta->make_immutable;

1;
