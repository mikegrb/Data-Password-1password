package Data::Password::1password::WebForm;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;
use Data::Password::1password::WebForm::Data;

with 'Data::Password::1password::Roles::Content';
with 'Data::Password::1password::Roles::DecryptedData';
with 'Data::Password::1password::Roles::LoginCreds';

has [qw(uuid title domain)] => ( isa => 'Str', is => 'ro' );

has 'data' => (
    isa        => 'Data::Password::1password::WebForm::Data',
    is         => 'ro',
    lazy_build => 1,
    handles    => [ qw(
            contentsHash location typeName encrypted securityLevel
            locationKey createdAt updatedAt openContents keyID
            )
    ],
);

sub _build_data {
    my $self = shift;
    return Data::Password::1password::WebForm::Data->new(
        filename => $self->filename );
}

__PACKAGE__->meta->make_immutable;

1;

