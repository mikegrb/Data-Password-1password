
package Data::Password::1password::Item::Password;

use Moose;
use namespace::autoclean;

use Data::Password::1password::Types;
use Data::Password::1password::Item::Password::Data;

with 'Data::Password::1password::Roles::Item';

has [qw(uuid title domain)] => ( isa => 'Str', is => 'ro' );
has filename => ( isa => 'ExistingPath', is => 'ro');
has data     => (
    isa        => 'Data::Password::1password::Item::Password::Data',
    is         => 'ro',
    lazy_build => 1,
    handles    => [ qw(
            contentsHash location typeName encrypted securityLevel
            locationKey createdAt updatedAt
            )
    ],
);

sub _build_data {
    my $self = shift;
    return Data::Password::1password::Item::Password::Data->new(
        filename => $self->filename );
}

__PACKAGE__->meta->make_immutable;

1;

