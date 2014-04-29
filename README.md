This distribution is a work in progress.

The path from here to the eventual release on the CPAN is almost
certainly not a straight line.

I like turtles.

I'm getting closer... folowing code now works:

```perl
#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use Data::Password::1password;
use IO::Prompt;

my $master_pass = prompt( 'Master Key> ', -echo => '' )->{value};

my $onepass = Data::Password::1password->new(
    master_pass => $master_pass,
    path => '/home/mikegrb/Dropbox/1Password.agilekeychain'
);


my $item = $onepass->contents->search( 'title', 'Keybase' )->[0];
say $item->password;

```