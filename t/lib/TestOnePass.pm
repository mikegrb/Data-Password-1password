package TestOnePass;

use strict;

use FindBin;

use Data::Password::1password;

my $keychain_path = $FindBin::Bin . '/data/demo.agilekeychain';

our $opass = Data::Password::1password->new(
    master_pass => 'demo',
    path        => $keychain_path,
);

sub import {
    my $package = shift;
    no strict 'refs';
    *{ caller . '::opass' } = \${ $package . '::opass' };
}

1;
