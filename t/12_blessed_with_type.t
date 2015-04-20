# copied over from JSON::XS and modified to use JSON

use strict;
use Test::More;
BEGIN { plan tests => 30 };

BEGIN { $ENV{PERL_JSON_BACKEND} = "JSON::backportPP"; }

use JSON;

my $o1 = bless { a => 3 }, "XX";
my $o2 = bless \(my $dummy = 1), "YY";

sub XX::TO_JSON_WITH_TYPE {return HASH=>['__',""]};

my $js = JSON->new;

eval { $js->encode ($o1) }; ok ($@ =~ /allow_blessed/);
eval { $js->encode ($o2) }; ok ($@ =~ /allow_blessed/);
$js->allow_blessed;
ok ($js->encode ($o1) eq "null");
ok ($js->encode ($o2) eq "null");
$js->convert_blessed;
ok ($js->encode ($o1) eq '{"__":""}');
ok ($js->encode ($o2) eq "null");

{package XA; sub TO_JSON_WITH_TYPE {return NUMBER=>1.1};}
is($js->encode (bless {}, 'XA'), '1.1', "TO_JSON_WITH_TYPE NUMBER");

{package XB; sub TO_JSON_WITH_TYPE {return NUMBER=>"1.1"};}
is($js->encode (bless {}, 'XB'), '1.1', "TO_JSON_WITH_TYPE NUMBER");

{package XC; sub TO_JSON_WITH_TYPE {return STRING=>1.1};}
is($js->encode (bless {}, 'XC'), '"1.1"', "TO_JSON_WITH_TYPE STRING");

{package XD; sub TO_JSON_WITH_TYPE {return STRING=>"1.1"};}
is($js->encode (bless {}, 'XD'), '"1.1"', "TO_JSON_WITH_TYPE STRING");

{package XE; sub TO_JSON_WITH_TYPE {return SCALAR=>1.1};}
is($js->encode (bless {}, 'XE'), '1.1', "TO_JSON_WITH_TYPE SCALAR");

{package XF; sub TO_JSON_WITH_TYPE {return SCALAR=>"1.1"};}
is($js->encode (bless {}, 'XF'), '"1.1"', "TO_JSON_WITH_TYPE SCALAR");

{package XG; sub TO_JSON_WITH_TYPE {return ARRAY=>[qw{a b c d}]};}
is($js->encode (bless {}, 'XG'), '["a","b","c","d"]', "TO_JSON_WITH_TYPE ARRAY");

{package XH; sub TO_JSON_WITH_TYPE {return HASH=>[a=>1,b=>2,c=>3]};}
is($js->encode (bless {}, 'XH'), '{"a":1,"b":2,"c":3}', "TO_JSON_WITH_TYPE HASH");

{package XI; sub TO_JSON_WITH_TYPE {return HASH=>{a=>1}};}
is($js->encode (bless {}, 'XI'), '{"a":1}', "TO_JSON_WITH_TYPE HASH");

{package XJ; sub TO_JSON_WITH_TYPE {return OBJECT=>{foo=>{bar=>'buz'}}};}
is($js->encode (bless {}, 'XJ'), '{"foo":{"bar":"buz"}}', "TO_JSON_WITH_TYPE OBJECT");

{package XL; sub TO_JSON_WITH_TYPE {return UNDEF=>undef};}
is($js->encode (bless {}, 'XL'), 'null', "TO_JSON_WITH_TYPE UNDEF");

{package XM; sub TO_JSON_WITH_TYPE {return NULL=>undef};}
is($js->encode (bless {}, 'XM'), 'null', "TO_JSON_WITH_TYPE NULL");

{package XN; sub TO_JSON_WITH_TYPE {return UNDEF=>()};}
is($js->encode (bless {}, 'XN'), 'null', "TO_JSON_WITH_TYPE UNDEF");

{package XO; sub TO_JSON_WITH_TYPE {return NULL=>()};}
is($js->encode (bless {}, 'XO'), 'null', "TO_JSON_WITH_TYPE NULL");

{package XP; sub TO_JSON_WITH_TYPE {return BOOLEAN=>undef};}
is($js->encode (bless {}, 'XP'), 'false', "TO_JSON_WITH_TYPE BOOLEAN");

{package XQ; sub TO_JSON_WITH_TYPE {return BOOLEAN=>1};}
is($js->encode (bless {}, 'XQ'), 'true', "TO_JSON_WITH_TYPE BOOLEAN");

{package XR; sub TO_JSON_WITH_TYPE {return BOOLEAN=>0};}
is($js->encode (bless {}, 'XR'), 'false', "TO_JSON_WITH_TYPE BOOLEAN");

{package XS; sub TO_JSON_WITH_TYPE {return BOOLEAN=>()};}
is($js->encode (bless {}, 'XS'), 'false', "TO_JSON_WITH_TYPE BOOLEAN");

{package XT; sub TO_JSON_WITH_TYPE {return BOOLEAN=>"0E0"};} #true but zero in Perl
is($js->encode (bless {}, 'XT'), 'true', "TO_JSON_WITH_TYPE BOOLEAN");

{package XU; sub TO_JSON_WITH_TYPE {return BOOLEAN=>"true"};}  #this is "true"
is($js->encode (bless {}, 'XU'), 'true', "TO_JSON_WITH_TYPE BOOLEAN");

{package XV; sub TO_JSON_WITH_TYPE {return BOOLEAN=>"false"};}  #this is "true" not false
is($js->encode (bless {}, 'XV'), 'true', "TO_JSON_WITH_TYPE BOOLEAN");

{package FA; sub TO_JSON_WITH_TYPE {return HASH=>[a=>1,b=>2,c=>3, "f"]};}
eval { $js->encode (bless {}, 'FA') }; ok ($@ =~ m/must have even/, "TO_JSON_WITH_TYPE HASH uneven array");

{package FB; sub TO_JSON_WITH_TYPE {return HASH=>\"scalar ref"};}
eval { $js->encode (bless {}, 'FB') }; ok ($@ =~ m/requires HASH or ARRAY reference/i, "TO_JSON_WITH_TYPE HASH with wrong payload");

{package FB; sub TO_JSON_WITH_TYPE {return HASH=>()};}
eval { $js->encode (bless {}, 'FB') }; ok ($@ =~ m/requires HASH or ARRAY reference/i, "TO_JSON_WITH_TYPE HASH with wrong payload");

