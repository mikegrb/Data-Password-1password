package Data::Password::1password::Roles::Content;

use Moose::Role;

has 'filename' => ( isa => 'ExistingPath', is => 'ro' );

has 'root' =>
    ( isa => 'Data::Password::1password', is => 'ro', weak_ref => 1 );

1;
