use strict;
use Test::More;
my $XS;

BEGIN {
  $ENV{PERL_JSON_BACKEND} = 2;
  eval "use JSON ();";
  $XS = JSON->backend;
  plan (JSON->backend->is_xs ? (tests => 2) : (skip_all => "no XS"));
}

use JSON ();

{
  no strict 'refs';
  is("" . ${"$XS\::true"}, 'true');
  is("" . JSON::true,   'true');
}

