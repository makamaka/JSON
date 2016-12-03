use strict;
use Test::More;
BEGIN { plan tests => 2 };
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }
use JSON;

my $json = JSON->new;
my $kb = 'a' x 1024;
my $hash = { map { $_ => $kb } (1..40) };
my $data = join ( '', $json->encode($hash), $json->encode($hash) );
my $size = length($data);
# note "Total size: [$size]";
my $offset = 0;
while ($size) {
    # note "Bytes left [$size]";
    my $incr = substr($data, $offset, 4096);
    my $bytes = length($incr);
    $size -= $bytes;
    $offset += $bytes;
    if ($bytes) {
        $json->incr_parse($incr);
    }
    while( my $obj = $json->incr_parse ) {
        ok "Got JSON object";
    }
}
