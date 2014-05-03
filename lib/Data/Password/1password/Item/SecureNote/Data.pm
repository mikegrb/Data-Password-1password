package Data::Password::1password::Item::SecureNote::Data;

use Moose;
use namespace::autoclean;

use Data::Password::1password::Types;

with 'Data::Password::1password::Roles::Data';

__PACKAGE__->meta->make_immutable;

1;
