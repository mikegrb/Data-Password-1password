package Data::Password::1password::Item::CreditCard;

use Moose;
use namespace::autoclean;

use Data::Password::1password::Types;
use Data::Password::1password::Item::CreditCard::Data;

with 'Data::Password::1password::Roles::Item';
with 'Data::Password::1password::Roles::DecryptedData';

has data => (
    isa        => 'Data::Password::1password::Item::CreditCard::Data',
    is         => 'ro',
    lazy_build => 1,
    handles    => [
        qw(contentsHash typeName encrypted securityLevel createdAt updatedAt keyID)
    ],
);

sub cardholder    { return shift->decrypted_data->{cardholder} }
sub ccnum         { return shift->decrypted_data->{ccnum} }
sub cvv           { return shift->decrypted_data->{cvv} }
sub expiry_mm     { return shift->decrypted_data->{expiry_mm} }
sub expiry_yy     { return shift->decrypted_data->{expiry_yy} }
sub phoneTollFree { return shift->decrypted_data->{phoneTollFree} }
sub type          { return shift->decrypted_data->{type} }

sub _build_data {
    my $self = shift;
    return Data::Password::1password::Item::CreditCard::Data->new(
        filename => $self->filename );
}

__PACKAGE__->meta->make_immutable;

1;
