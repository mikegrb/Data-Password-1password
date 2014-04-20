package Data::Password::1password::Keys;

use Moose;
use namespace::autoclean;
use Data::Dumper;

use Data::Password::1password::Types;
use Data::Password::1password::Key;

with 'Data::Password::1password::Roles::json';

has 'path' => ( isa => 'ExistingPath', is => 'ro' );

has 'filename' => (
    isa     => 'ExistingPath',
    is      => 'ro',
    lazy    => 1,
    builder => '_build_filename'
);

has 'keys' => (
    traits  => ['Hash'],
    is      => 'ro',
    isa     => 'HashRef[Data::Password::1password::Key]',
    handles => { get_key => 'get' },
    lazy    => 1,
    builder => '_build_keys',
);

has 'levels' => (
    traits  => ['Hash'],
    is      => 'ro',
    isa     => 'HashRef[Str]',
    handles => { get_level_key_id => 'get' },
);

sub _build_filename { return shift->path . '/data/default/encryptionKeys.js' }

sub _build_keys {
    my $self    = shift;
    my $content = $self->_json_from_file( $self->filename );

    for my $level ( keys %$content ) {
        next if $level eq 'list';
        $self->{levels}{$level} = $content->{$level};
    }

    my $keys = {};
    for my $key ( @{ $content->{list} } ) {
        $keys->{ $key->{identifier} }
            = Data::Password::1password::Key->new(%$key);
    }

    return $keys;
}

sub key_for_level {
    my ( $self, $level ) = @_;
    return $self->get_key( $self->get_level_key_id($level) );
}

__PACKAGE__->meta->make_immutable;

1;
