use strict;
use Test::More;

BEGIN { plan tests => 1 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

SKIP: { skip "requires $JSON::BackendModule 2.90 or newer", 1 if JSON->backend->is_pp and eval $JSON::BackendModule->VERSION < 2.90;
    eval { JSON->new->decode('{}0') };
    ok $@;
}
