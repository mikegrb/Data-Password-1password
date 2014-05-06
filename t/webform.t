use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use TestOnePass;
use Test::More;

my $citiwebform = $opass->contents->search('title', 'Citi')->[0];

is ($citiwebform->username, '852083482143', 'get username');
is ($citiwebform->password, 'BVxVhnk3CYNMoTxABHhQ', 'get password');

done_testing();
