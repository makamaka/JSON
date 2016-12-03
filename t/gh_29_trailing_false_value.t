use strict;
use Test::More;

BEGIN { plan tests => 1 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

eval { JSON->new->decode('{}0') };
ok $@;
