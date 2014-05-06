use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use TestOnePass;
use Test::More;

my $item = $opass->contents->search( 'title', 'PAUSE' )->[0];

is( ref $item->fields, 'HASH', 'right datatype for fields' );
is( $item->fields->{password}, 'W7nsuGT>YYb72o3e', 'password' );

done_testing();
