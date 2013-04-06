use strict;
use Test::More;
BEGIN { plan tests => 2 };

BEGIN { $ENV{PERL_JSON_BACKEND} = 1; }

use JSON ();

SKIP: {
    eval 'use JSON::XS ()';

    skip "can't use JSON::XS.", 2, if $@;
    skip "JSON::XS version < " . JSON->require_xs_version, 2
            if JSON::XS->VERSION < JSON->require_xs_version;

    is("" . JSON::XS::true, 'true');
    is("" . JSON::true,     'true');
}

