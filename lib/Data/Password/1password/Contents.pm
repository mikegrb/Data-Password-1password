package Data::Password::1password::Contents;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;

with 'Data::Password::1password::Roles::json';

has 'contents' => (
    isa => 'ArrayRef[]',
    is  => 'ro',
);

has 'path'     => ( isa => 'ExistingPath', is => 'ro' );
has 'filename' => ( isa => 'ExistingPath', is => 'ro' );

sub BUILD {
    my ( $self, $params ) = @_;
    $self->meta->get_attribute('filename')->set_value( $self, $self->path . '/contents.js' );
    if ( $self->filename ) {
        my @content_objs;
        my $contents = $self->_json_from_file( $self->filename );
        for my $item (@$contents) {
            my %data;
            @data{ 'uuid',  'title', 'domain' } = @$item[ 0, 2, 3 ];

            (my $class = $item->[1]) =~  s/^.*\.([^\.]+)$/$1/;
            next unless $class ~~ [ 'WebForm', 'Password' ];
            $class = 'Data::Password::1password::' . $class;

            push @content_objs, $class->new(
                filename => $self->path . '/' . $data{uuid} . '.1password',
                %data
            );
        }
        $self->{contents} = \@content_objs;
    }
}

sub search {
    my ( $self, $atrib, $re ) = @_;
    return [ grep { $_->$atrib() =~ m/$re/  } @{ $self->contents } ];
}

__PACKAGE__->meta->make_immutable;

1;