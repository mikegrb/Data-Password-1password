package Data::Password::1password::Roles::json;

use Moose::Role;
use JSON::Any;
use File::Slurp;

sub _build_from_filename {
    my $self = shift;
    my $data = $self->_json_from_file( $self->filename );
    $self->meta->get_attribute($_)->set_value( $self, $data->{$_} )
        for keys %$data;
}

sub _json_from_file {
    my ( $self, $path ) = @_;
    my $json = read_file($path);
    $json =~ s/\n/ /g;
    return JSON::Any->jsonToObj($json);
}

1;