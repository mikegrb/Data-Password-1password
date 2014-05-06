use strict;

use FindBin;
use lib $FindBin::Bin . '/lib';

use TestOnePass;
use Test::More;

my $note = $opass->contents->search('title', 'Apple Store Information')->[0];

my $correct_text = q{San Francisco:

Address:
   One Stockton Street
   San Francisco, CA 94108
   (415) 392-0202

Store hours:
   Mon - Sat:9:00 a.m. - 9:00 p.m.
   Sun:11:00 a.m. - 8:00 p.m.};

is($note->text, $correct_text, 'correct note text');

done_testing();
