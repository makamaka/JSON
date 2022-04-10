use strict;
use warnings;
use Test::More tests => 18;
BEGIN { $ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }

use JSON;

my $json = JSON->new;

is $json->get_core_bools, !!0, 'core_bools initially false';

my $ret = $json->core_bools;
is $ret => $json, "returns the same object";

SKIP: {
    skip "core_bools option doesn't register as true without core boolean support", 1
        unless JSON::CORE_BOOL;
    is $json->get_core_bools, !!1, 'core_bools option enabled';
}

my ($new_false, $new_true) = $json->get_boolean_values;

ok defined $new_true, "core true value is defined";
ok defined $new_false, "core false value is defined";

ok !ref $new_true, "core true value is not blessed";
ok !ref $new_false, "core falase value is not blessed";

{
    my @warnings;
    local $SIG{__WARN__} = sub {
        push @warnings, @_;
        warn @_;
    };

    cmp_ok $new_true, 'eq', '1', 'core true value is "1"';
    cmp_ok $new_true, '==', 1, 'core true value is 1';

    cmp_ok $new_false, 'eq', '', 'core false value is ""';
    cmp_ok $new_false, '==', 0, 'core false value is 0';

    is scalar @warnings, 0, 'no warnings';
}

SKIP: {
    skip "core boolean support needed to detect core booleans", 2
        unless JSON::CORE_BOOL;
    ok JSON::is_bool($new_true), 'core true is a boolean';
    ok JSON::is_bool($new_false), 'core false is a boolean';
}

my $should_true = $json->allow_nonref(1)->decode('true');
my $should_false = $json->allow_nonref(1)->decode('false');

ok !ref $should_true && $should_true, "JSON true turns into an unblessed true value";
ok !ref $should_false && !$should_false, "JSON false turns into an unblessed false value";

SKIP: {
    skip "core boolean support needed to detect core booleans", 2
        unless JSON::CORE_BOOL;
    ok JSON::is_bool($should_true), 'decoded true is a boolean';
    ok JSON::is_bool($should_false), 'decoded false is a boolean';
}
