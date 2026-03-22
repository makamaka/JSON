use strict;
use warnings;
use Test::More;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

BEGIN { plan skip_all => "requires $JSON::BackendModule 4.18 or newer" if JSON->backend->is_pp and eval $JSON::BackendModule->VERSION < 4.18 }

plan tests => 3;

# from GH#61

sub MyClass::new { bless {}, shift }
sub MyClass::TO_JSON { encode_json([]) }

ok my $json = JSON->new->convert_blessed;
is $json->encode([MyClass->new]) => '["[]"]';
my $res = eval { $json->encode([MyClass->new, MyClass->new]) };
is $res => '["[]","[]"]';
