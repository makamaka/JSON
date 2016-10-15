use strict;
use Test::More;
BEGIN { plan tests => 1 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

my $json = JSON->new;

my $input = q[
{
   "dynamic_config" : 0,
   "x_contributors" : [
      "å¤§æ²¢ åå®",
      "Ãvar ArnfjÃ¶rÃ°"
   ]
}
];
eval { $json->decode($input) };
is $@, '', 'decodes 0 with mojibake without error';
