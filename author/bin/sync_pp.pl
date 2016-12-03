# This script is to sync JSON::backportPP with the latest JSON::PP

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";
use Path::Tiny;
use JSON;

my $re_pp_methods = join '|', JSON->pureperl_only_methods;

my $root = path("$FindBin::Bin/../..");
my $pp_root = $root->parent->child('JSON-PP');
my $test_dir = $root->child('t');

die "JSON-PP directory not found" unless -d $pp_root;

{
    my $pp_lib = $pp_root->child('lib/JSON/PP.pm');
    my $content = $pp_lib->slurp;
    $content =~ s/^package /package # This is JSON::backportPP\n    /;
    $content =~ s/^( *)package (JSON::PP(?:::(?:Boolean|IncrParser))?);/$1package # hide from PAUSE\n$1  $2;/gm;
    $content =~ s/use JSON::PP::Boolean/use JSON::backportPP::Boolean/;
    $content =~ s/JSON::PP::Compat/JSON::backportPP::Compat/g;
    $content =~ s/\$JSON::PP::([\w:]+)?VERSION/\$JSON::backportPP::$1VERSION/g;
    $content =~ s/\@JSON::PP::ISA/\@JSON::backportPP::ISA/g;
    $root->child('lib/JSON/backportPP.pm')->spew($content);
}

{
    my $pp_lib = $pp_root->child('lib/JSON/PP/Boolean.pm');
    my $content = $pp_lib->slurp;
    $content =~ s/^package /package # This is JSON::backportPP\n    /;
    $content =~ s/^( *)package (JSON::PP(?:::(?:Boolean|IncrParser))?);/$1package # hide from PAUSE\n$1  $2;/gm;
    $content =~ s/\$JSON::PP::([\w:]+)?VERSION/\$JSON::backportPP::$1VERSION/g;
    $content =~ s/JSON::PP( )/JSON::backportPP$1/g;
    $root->child('lib/JSON/backportPP/Boolean.pm')->spew($content);
}

for my $pp_test ($pp_root->child('t')->children) {
    my $basename = $pp_test->basename;
    $basename =~ s/^0([0-9][0-9])/$1/;
    my $json_test = $test_dir->child($basename);
    if ($basename =~ /\.pm$/) {
        my $content = $pp_test->slurp;
        $content =~ s/JSON::PP::/JSON::/g;
        $json_test->spew($content);
        print STDERR "copied $pp_test to $json_test\n";
        next;
    }
    if ($basename =~ /\.t$/) {
        my $content = $pp_test->slurp;
        $content =~ s/JSON::PP(::|->|;| |\.|$)/JSON$1/mg;
        $content =~ s/\$ENV{PERL_JSON_BACKEND} = 0/\$ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"/;
        if ($content !~ /\$ENV{PERL_JSON_BACKEND}/) {
            $content =~ s/use JSON;/BEGIN { \$ENV{PERL_JSON_BACKEND} ||= "JSON::backportPP"; }\n\nuse JSON;/;
        }

        if ($content =~ /$re_pp_methods/) {
            $content =~ s/use JSON;/use JSON -support_by_pp;/g;
        }

        # special cases
        if ($basename eq '104_sortby.t') {
            $content =~ s/JSON::hoge/JSON::PP::hoge/g;
            $content =~ s/\$JSON::(a|b)\b/\$JSON::PP::$1/g;
        }

        $json_test->spew($content);
        print STDERR "copied $pp_test to $json_test\n";
        next;
    }
    print STDERR "Skipped $pp_test\n";
}
