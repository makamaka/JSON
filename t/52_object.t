# copied over from JSON::XS and modified to use JSON

use strict;
use Test::More;
BEGIN { $^W = 0 } # hate

BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

my $backend_version = JSON->backend->VERSION; $backend_version =~ s/_//;

plan skip_all => "allow_tags is not supported" if $backend_version < 3;

plan tests => 20;

my $json = JSON->new->convert_blessed->allow_tags->allow_nonref;

ok (1);

sub JSON::tojson::TO_JSON {
   ok (@_ == 1);
   ok (JSON::tojson:: eq ref $_[0]);
   ok ($_[0]{k} == 1);
   7
}

my $obj = bless { k => 1 }, JSON::tojson::;

ok (1);

my $enc = $json->encode ($obj);
ok ($enc eq 7);

ok (1);

sub JSON::freeze::FREEZE {
   ok (@_ == 2);
   ok ($_[1] eq "JSON");
   ok (JSON::freeze:: eq ref $_[0]);
   ok ($_[0]{k} == 1);
   (3, 1, 2)
}

sub JSON::freeze::THAW {
   ok (@_ == 5);
   ok (JSON::freeze:: eq $_[0]);
   ok ($_[1] eq "JSON");
   ok ($_[2] == 3);
   ok ($_[3] == 1);
   ok ($_[4] == 2);
   777
}

my $obj = bless { k => 1 }, JSON::freeze::;
my $enc = $json->encode ($obj);
ok ($enc eq '("JSON::freeze")[3,1,2]');

my $dec = $json->decode ($enc);
ok ($dec eq 777);

ok (1);

