package Data::Password::1password::Roles::Item;

use Moose::Role;


has [qw(uuid title domain)] => ( isa => 'Str', is => 'ro' );

has 'filename' => ( isa => 'ExistingPath', is => 'ro' );

has 'root' =>
    ( isa => 'Data::Password::1password', is => 'ro', weak_ref => 1 );

1;
