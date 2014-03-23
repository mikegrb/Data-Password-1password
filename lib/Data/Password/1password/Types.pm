package Data::Password::1password::Types;

use Moose::Util::TypeConstraints;

subtype 'ExistingPath' => as Str => where { -e $_ };

1;