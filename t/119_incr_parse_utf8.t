use strict;
use warnings;
use Test::More;

use utf8;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;
plan skip_all => "not for older version of JSON::PP" if JSON->backend->isa('JSON::PP') && JSON->backend->VERSION < 4.07;
use Encode;
use charnames qw< :full >;

plan tests => 24;

use vars qw< @vs >;

############################################################
###  These first tests mimic the ones in `t/001_utf8.t`  ###
############################################################

scalar eval { JSON->new->allow_nonref (1)->utf8 (1)->incr_parse ('"ü"') };
like $@, qr/malformed UTF-8/;

ok (JSON->new->allow_nonref (1)->incr_parse ('"ü"') eq "ü");
ok (JSON->new->allow_nonref (1)->incr_parse ('"\u00fc"') eq "ü");
ok (JSON->new->allow_nonref (1)->incr_parse ('"\ud801\udc02' . "\x{10204}\"") eq "\x{10402}\x{10204}");
ok (JSON->new->allow_nonref (1)->incr_parse ('"\"\n\\\\\r\t\f\b"') eq "\"\012\\\015\011\014\010");


my $JSON_TXT = <<JSON_TXT;
{ "a": "1" }
{ "b": "\N{BULLET}" }
{ "c": "3" }
JSON_TXT

#######################
###  With '->utf8'  ###
#######################

@vs = eval { JSON->new->utf8->incr_parse( $JSON_TXT ) };
like $@, qr/Wide character in subroutine entry/;


@vs = eval { JSON->new->utf8->incr_parse( encode 'UTF-8' => $JSON_TXT ) };

ok( !$@ );
ok( scalar @vs == 3 );

is_deeply( \@vs, [ { a => "1" }, { b => "\N{BULLET}" }, { c => "3" } ] );
is_deeply( $vs[0], { a => "1" } );
is_deeply( $vs[1], { b => "\N{BULLET}" } );
is_deeply( $vs[2], { c => "3" } );


# Double-Encoded => "You Get What You Ask For"

@vs = eval { JSON->new->utf8->incr_parse( encode 'UTF-8' => ( encode 'UTF-8' => $JSON_TXT ) ) };

ok( !$@ );
ok( scalar @vs == 3 );

is_deeply( \@vs, [ { a => "1" }, { b => "\x{E2}\x{80}\x{A2}" }, { c => "3" } ] );
is_deeply( $vs[0], { a => "1" } );
is_deeply( $vs[1], { b => "\x{E2}\x{80}\x{A2}" } );
is_deeply( $vs[2], { c => "3" } );


##########################
###  Without '->utf8'  ###
##########################

@vs = eval { JSON->new->incr_parse( $JSON_TXT ) };

ok( !$@ );
ok( scalar @vs == 3 );

is_deeply( \@vs, [ { a => "1" }, { b => "\N{BULLET}" }, { c => "3" } ] );
is_deeply( $vs[0], { a => "1" } );
is_deeply( $vs[1], { b => "\N{BULLET}" } );
is_deeply( $vs[2], { c => "3" } );
