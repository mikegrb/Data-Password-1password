package Data::Password::1password::WebForm;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;
use Data::Password::1password::WebForm::Data;

has [qw(uuid title domain)] => ( isa => 'Str', is => 'ro' );
has 'filename' => ( isa => 'ExistingPath', is => 'ro' );
has 'root' =>
    ( isa => 'Data::Password::1password', is => 'ro', weak_ref => 1 );
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

