use strict;

use FindBin;
use Test::More;
use Test::Exception;

use Data::Password::1password;

my $keychain_path = $FindBin::Bin . '/data/demo.agilekeychain';

my $opass = Data::Password::1password->new(
    master_pass => 'wrong',
    path        => $keychain_path,
);

my $citiwebform = $opass->contents->search('title', 'Citi');

is (@$citiwebform, 2, 'search finds correct entries' );

$citiwebform = $citiwebform->[0];

throws_ok { $citiwebform->decrypted_data } qr/Bad passphrase!/,
    'detects incorrect passphrase';

$opass->master_pass('demo');

is ($citiwebform->username, '852083482143', 'get username');
is ($citiwebform->password, 'BVxVhnk3CYNMoTxABHhQ', 'get password');

done_testing();