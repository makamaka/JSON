use strict;
use Test::More;
BEGIN { plan tests => 2 };

BEGIN { $ENV{PERL_JSON_BACKEND} = "JSON::XS"; }

use JSON::XS ();
use JSON ();

is("" . JSON::XS::true, 'true');
is("" . JSON::true,     'true');

