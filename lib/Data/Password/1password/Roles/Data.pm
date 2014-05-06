package Data::Password::1password::Roles::Data;

use Moose::Role;
use JSON::Any;
use File::Slurp;
use Data::Dumper;
use Data::Printer;
use Try::Tiny;

has [
    qw( domain title createdAt updatedAt folderUuid
        contentsHash location typeName uuid encrypted securityLevel
        locationKey keyID )
]                  => ( isa => 'Str',          is => 'ro' );
has 'openContents' => ( isa => 'HashRef',      is => 'ro' );
has 'filename'     => ( isa => 'ExistingPath', is => 'ro' );
has 'trashed'      => ( isa => 'Bool',         is => 'ro' );
has 'faveIndex'    => ( isa => 'Num',          is => 'ro' );

sub BUILD {
    my ( $self, $params ) = @_;
    return $self->_build_from_filename if $self->filename;
}

sub _build_from_filename {
    my $self = shift;
    return $self->_build_from_data( $self->_json_from_file( $self->filename ) );
}

sub _json_from_file {
    my ( $self, $path ) = @_;
    my $json = read_file($path);
    $json =~ s/\n/ /g;
    return JSON::Any->jsonToObj($json);
}

sub _build_from_data {
    my ( $self, $data ) = @_;
    for my $attr ( keys %$data ) {
        try {
            $self->meta->get_attribute($attr)
                ->set_value( $self, $data->{$attr} );
        }
        catch {
            p $_;
            print "No method for $attr\n";
            p $data;

        };
    }

}

1;
