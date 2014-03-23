package Data::Password::1password::Roles::Content;

use Moose::Role;
use JSON::Any;
use File::Slurp;
use Data::Dumper;

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
    print Dumper $data;
    for ( keys %$data ) {
        warn $_;
        $self->meta->get_attribute($_)->set_value( $self, $data->{$_} );
    }

}

1;
