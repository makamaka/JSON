# copied over from JSON::XS and modified to use JSON

use strict;
use Test::More;
BEGIN { plan tests => 10 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use utf8;
use JSON;

SKIP: {
    skip "no JSON::XS < 3", 5 unless eval { require JSON::XS; JSON::XS->VERSION < 3 };

    my $false = JSON::XS::false();
    ok (JSON::is_bool $false);
    ok (++$false == 1);
    ok (!JSON::is_bool $false);
    ok (!JSON::is_bool "JSON::Boolean");
    ok (!JSON::is_bool {}); # GH-34
}

SKIP: {
    skip "no Types::Serialiser 0.01", 5 unless eval { require JSON::XS; JSON::XS->VERSION(3.00); require Types::Serialiser; Types::Serialiser->VERSION == 0.01 };

    my $false = JSON::XS::false();
    ok (JSON::is_bool $false);
    ok (++$false == 1);
    ok (!JSON::is_bool $false);
    ok (!JSON::is_bool "JSON::Boolean");
    ok (!JSON::is_bool {}); # GH-34
}
