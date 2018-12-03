use Test::More;
use strict;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }
BEGIN { $ENV{PERL_JSON_PP_USE_B} = 0 }
use JSON;

BEGIN { plan skip_all => "requires $JSON::BackendModule 2.90 or newer" if JSON->backend->is_pp and eval $JSON::BackendModule->VERSION < 2.90 }
BEGIN { plan skip_all => "not for $JSON::BackendModule" if $JSON::BackendModule eq 'JSON::XS' }

BEGIN { plan tests => 3 }

# TODO ("inf"/"nan" representations are not portable)
# is encode_json([9**9**9]), '["inf"]';
# is encode_json([-sin(9**9**9)]), '["nan"]';

my $num = 3;
my $str = "$num";
is encode_json({test => [$num, $str]}), '{"test":[3,"3"]}';
$num = 3.21;
$str = "$num";
is encode_json({test => [$num, $str]}), '{"test":[3.21,"3.21"]}';
$str = '0 but true';
$num = 1 + $str;
is encode_json({test => [$num, $str]}), '{"test":[1,"0 but true"]}';
