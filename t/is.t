#!/usr/bin/perl

use warnings;
use strict;

use Test::More;
BEGIN { plan tests => 2 };

BEGIN {
    use_ok('JSON');
}

my $json = JSON->new();
ok (defined ($json->is_pp()), '$json->is_pp()');
ok (defined ($json->is_xs()), '$json->is_xs()');

