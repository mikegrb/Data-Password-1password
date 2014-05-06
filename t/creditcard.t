use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use TestOnePass;
use Test::More;

my $card = $opass->contents->search( 'title', 'CIBC' )->[0];

is( $card->bank,        'CIBC',                'bank' );
is( $card->cardholder,  'Wendy Appleseed',     'cardholder' );
is( $card->ccnum,       '4500 6500 1234 5678', 'ccnum' );
is( $card->creditLimit, '$9,000',              'creditLimit' );
is( $card->cvv,         123,                   'cvv' );
is( $card->expiry_mm,   8,                     'expiry_mm' );
is( $card->expiry_yy,   2015,                  'expiry_yy' );

done_testing();
