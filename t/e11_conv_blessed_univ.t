
use strict;
use Test::More;
BEGIN { plan tests => 7 };

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON -convert_blessed_universally;

ok( !MyTest->can('TO_JSON') );
ok( MyTest2->can('TO_JSON') );

my $obj  = MyTest->new( [ 1, 2, {foo => 'bar'} ] );

$obj->[3] = MyTest2->new( { a => 'b' } );

my $json = JSON->new->allow_blessed->convert_blessed;

is( $json->encode( $obj ), '[1,2,{"foo":"bar"},"hoge"]'  );

$json->convert_blessed(0);

is( $json->encode( $obj ), 'null' );

$json->allow_blessed(0)->convert_blessed(1);

is( $json->encode( $obj ), '[1,2,{"foo":"bar"},"hoge"]'  );

SKIP: {
    skip "only works with 5.18+", 1 if $] < 5.018;
    ok( !MyTest->can('TO_JSON') );
}
ok( MyTest2->can('TO_JSON') );

package MyTest;

sub new {
    bless $_[1], $_[0];
}



package MyTest2;

sub new {
    bless $_[1], $_[0];
}

sub TO_JSON {
    "hoge";
}

