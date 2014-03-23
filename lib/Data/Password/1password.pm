package Data::Password::1password;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;

has 'path'          => ( isa => 'ExistingPath', is => 'ro' );

__PACKAGE__->meta->make_immutable;

1;
