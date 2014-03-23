package Data::Password::1password::WebForm::Data;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;

with 'Data::Password::1password::Roles::Content';

has [ qw(
        contentsHash location typeName uuid encrypted
        title securityLevel locationKey domain keyID
        ) ]        => ( isa => 'Str',          is => 'ro' );
has 'openContents' => ( isa => 'HashRef',      is => 'ro' );
has 'createdAt'    => ( isa => 'Str',          is => 'ro' );
has 'updatedAt'    => ( isa => 'Str',          is => 'ro' );
has 'filename'     => ( isa => 'ExistingPath', is => 'ro' );
has 'trashed'      => ( isa => 'Bool', is => 'ro' );
__PACKAGE__->meta->make_immutable;

1;
