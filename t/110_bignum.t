
use strict;
use Test::More;
BEGIN { plan tests => 7 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON -support_by_pp;

eval q| require Math::BigInt |;

SKIP: {
    skip "Can't load Math::BigInt.", 7 if ($@);

    my $v = Math::BigInt->VERSION;
    $v =~ s/_.+$// if $v;

my $fix =  !$v       ? '+'
          : $v < 1.6 ? '+'
          : '';


my $json = new JSON;

$json->allow_nonref->allow_bignum(1);
$json->convert_blessed->allow_blessed;

my $num  = $json->decode(q|100000000000000000000000000000000000000|);

isa_ok($num, 'Math::BigInt');
is("$num", $fix . '100000000000000000000000000000000000000');
is($json->encode($num), $fix . '100000000000000000000000000000000000000');

$num  = $json->decode(q|2.0000000000000000001|);

isa_ok($num, 'Math::BigFloat');
is("$num", '2.0000000000000000001');
is($json->encode($num), '2.0000000000000000001');

SKIP: { skip "requires $JSON::BackendModule 2.90 or newer", 1 if JSON->backend->is_pp and eval $JSON::BackendModulePP->VERSION < 2.90;
diag "$JSON::BackendModulePP $JSON::BackendModulePP->VERSION";
is($json->encode([Math::BigInt->new("0")]), '[0]', "zero bigint is 0 (the number), not '0' (the string)" );
}
}
