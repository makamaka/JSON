use strict;
use Test::More;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }
use JSON;

BEGIN { plan skip_all => "requires $JSON::BackendModule 2.90 or newer" if JSON->backend->is_pp and eval $JSON::BackendModule->VERSION < 2.90 }

BEGIN { plan tests => 2 };

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
