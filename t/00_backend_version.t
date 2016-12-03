use Test::More tests => 1;
use strict;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;
diag ($JSON::BackendModule);
diag ($JSON::BackendModule->VERSION);
ok 1;
