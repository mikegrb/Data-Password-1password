package Data::Password::1password::Contents;

use Moose;
use namespace::autoclean;

use Carp;
use Data::Dumper;

use Data::Password::1password::Types;
use Data::Password::1password::Item::Password;
use Data::Password::1password::Item::WebForm;
use Data::Password::1password::Item::SecureNote;

with 'Data::Password::1password::Roles::json';

has 'contents' => ( isa => 'ArrayRef[]', is => 'ro', );
has 'path'     => ( isa => 'ExistingPath', is => 'ro' );
has 'filename' => ( isa => 'ExistingPath', is => 'ro' );
has 'root' =>
    ( isa => 'Data::Password::1password', is => 'ro', weak_ref => 1 );

sub BUILD {
    no warnings 'experimental::smartmatch';
    my ( $self, $params ) = @_;
    $self->meta->get_attribute('filename')
        ->set_value( $self, $self->path . '/data/default/contents.js' );
    if ( $self->filename ) {
        my @content_objs;
        my $contents = $self->_json_from_file( $self->filename );
        for my $item (@$contents) {
            my %data;
            @data{ 'uuid', 'title', 'domain' } = @$item[ 0, 2, 3 ];

            ( my $class = $item->[1] ) =~ s/^.*\.([^\.]+)$/$1/;
            next unless $class ~~ [ qw(WebForm Password SecureNote) ];
            $class = 'Data::Password::1password::Item::' . $class;
            push @content_objs,
                $class->new(
                root     => $self->root,
                filename => $self->path
                    . '/data/default/'
                    . $data{uuid}
                    . '.1password',
                %data
                );
        }
        $self->{contents} = \@content_objs;
    }
}

sub search {
    my ( $self, $atrib, $re ) = @_;
    return [ grep { $_->$atrib() =~ m/$re/ } @{ $self->contents } ];
}

__PACKAGE__->meta->make_immutable;

1;
