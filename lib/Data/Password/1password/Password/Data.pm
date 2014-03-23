package Data::Password::1password::Password::Data;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;

with 'Data::Password::1password::Roles::Content';

has [ qw(
        contentsHash location typeName uuid encrypted securityLevel
        locationKey )
]               => ( isa => 'Str',          is => 'ro' );
has 'domain'    => ( isa => 'Str',          is => 'ro' );
has 'title'     => ( isa => 'Str',          is => 'ro' );
has 'createdAt' => ( isa => 'Str',          is => 'ro' );
has 'updatedAt' => ( isa => 'Str',          is => 'ro' );
has 'filename'  => ( isa => 'ExistingPath', is => 'ro' );

__PACKAGE__->meta->make_immutable;

1;
