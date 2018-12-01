# copied over from JSON::XS and modified to use JSON

use strict;
use Test::More;
BEGIN { plan tests => 4 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

my $pp = JSON->new->latin1->allow_nonref;

ok ($pp->encode ("\x{12}\x{89}       ") eq "\"\\u0012\x{89}       \"");
ok ($pp->encode ("\x{12}\x{89}\x{abc}") eq "\"\\u0012\x{89}\\u0abc\"");

ok ($pp->decode ("\"\\u0012\x{89}\""       ) eq "\x{12}\x{89}");
ok ($pp->decode ("\"\\u0012\x{89}\\u0abc\"") eq "\x{12}\x{89}\x{abc}");

