use strict;
use warnings;
use Test::More;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

BEGIN { plan skip_all => "requires $JSON::BackendModule 4.18 or newer" if JSON->backend->is_pp and eval $JSON::BackendModule->VERSION < 4.18 }

BEGIN { plan tests => 1 };

my $ds = eval { JSON::decode_json read_file() };
ok !$@, "No error" or note $@;

sub read_file {
	my $json = <<"JSON";
{
"camel": "Amelia"
}
JSON
	wantarray ? split(/\R/, $json) : $json;
}
