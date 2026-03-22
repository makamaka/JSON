use strict;
use warnings;
use Test::More;

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

BEGIN { plan skip_all => "requires $JSON::BackendModule 4.18 or newer" if JSON->backend->is_pp and eval $JSON::BackendModule->VERSION < 4.18 }

my $got = JSON->new->utf8->space_after(1)->encode({x=>[1,2]});
is $got => qq!{"x": [1, 2]}!, "has a space after 1";

done_testing;
