
package Data::Password::1password::Item::SecureNote;

use Moose;
use namespace::autoclean;

use Data::Password::1password::Types;
use Data::Password::1password::Item::SecureNote::Data;

with 'Data::Password::1password::Roles::Item';
with 'Data::Password::1password::Roles::DecryptedData';

has data => (
    isa        => 'Data::Password::1password::Item::SecureNote::Data',
    is         => 'ro',
    lazy_build => 1,
    handles =>
        [qw(contentsHash typeName encrypted securityLevel createdAt updatedAt keyID)],
);

sub text {
    my $self = shift;
    return $self->decrypted_data->{notesPlain};
}

sub _build_data {
    my $self = shift;
    return Data::Password::1password::Item::SecureNote::Data->new(
        filename => $self->filename );
}

__PACKAGE__->meta->make_immutable;

1;
