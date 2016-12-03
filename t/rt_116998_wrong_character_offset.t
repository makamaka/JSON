use strict;
use Test::More;
BEGIN { plan tests => 4 };
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }
use JSON;

SKIP: { skip "requires $JSON::BackendModule 2.90 or newer", 1 if $JSON::BackendModulePP and eval $JSON::BackendModulePP->VERSION < 2.90;
eval { decode_json(qq({"foo":{"bar":42})) };
like $@ => qr/offset 17/; # 16
}

eval { decode_json(qq(["foo",{"bar":42})) };
like $@ => qr/offset 17/;

SKIP: { skip "requires $JSON::BackendModule 2.90 or newer", 1 if $JSON::BackendModulePP and eval $JSON::BackendModulePP->VERSION < 2.90;
eval { decode_json(qq(["foo",{"bar":42}"])) };
like $@ => qr/offset 17/; # 18
}

eval { decode_json(qq({"foo":{"bar":42}"})) };
like $@ => qr/offset 17/;

