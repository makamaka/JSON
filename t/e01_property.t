
use Test::More;
use strict;

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

my @simples = 
    qw/ascii latin1 utf8 indent canonical space_before space_after allow_nonref shrink allow_blessed
        convert_blessed relaxed
     /;

my $json = new JSON;

# JSON::XS/JSON::PP 4.0 allow nonref by default
my $allow_nonref_by_default = $json->allow_nonref;

my $has_allow_tags = 0;
if ($json->can('allow_tags') and !ref $json->allow_tags) {
    push @simples, 'allow_tags';
    $has_allow_tags = 1;
}

plan tests => 90 + $has_allow_tags * 7;

for my $name (@simples) {
    my $method = 'get_' . $name;
    if ($name eq 'allow_nonref' and $allow_nonref_by_default) {
        ok( $json->$method(), $method . ' default');
    } else {
        ok(! $json->$method(), $method . ' default');
    }
    $json->$name();
    ok($json->$method(), $method . ' set true');
    $json->$name(0);
    ok(! $json->$method(), $method . ' set false');
    $json->$name();
    ok($json->$method(), $method . ' set true again');
}

ok($json->get_max_depth == 512, 'get_max_depth default');
$json->max_depth(7);
ok($json->get_max_depth == 7, 'get_max_depth set 7 => 7');
$json->max_depth();
ok($json->get_max_depth != 0, 'get_max_depth no arg');


ok($json->get_max_size == 0, 'get_max_size default');
$json->max_size(7);
ok($json->get_max_size == 7, 'get_max_size set 7 => 7');
$json->max_size();
ok($json->get_max_size == 0, 'get_max_size no arg');


for my $name (@simples) {
    $json->$name();
    ok($json->property($name), $name);
    $json->$name(0);
    ok(! $json->property($name), $name);
    $json->$name();
    ok($json->property($name), $name);
}


