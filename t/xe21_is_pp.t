use strict;
use Test::More;

BEGIN { plan tests => 5 };

BEGIN {
    $ENV{PERL_JSON_BACKEND} ||= 1;
}

use JSON;

my $json = JSON->new();

ok( $json->backend, 'backend is ' . $json->backend );

if ( $json->backend->is_xs ) {
    ok (!JSON->is_pp(), 'JSON->is_pp()');
    ok ( JSON->is_xs(), 'JSON->is_xs()');
    ok (!$json->is_pp(), '$json->is_pp()');
    ok ( $json->is_xs(), '$json->is_xs()');
}
else {
    ok ( JSON->is_pp(), 'JSON->is_pp()');
    ok (!JSON->is_xs(), 'JSON->is_xs()');
    ok ( $json->is_pp(), '$json->is_pp()');
    ok (!$json->is_xs(), '$json->is_xs()');
}

