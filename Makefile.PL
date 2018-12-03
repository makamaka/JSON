require 5.00503;
use strict;
use ExtUtils::MakeMaker;

use lib qw( ./lib );

$| = 1;

$ENV{PERL_JSON_BACKEND} = 'JSON::backportPP';
eval q| require JSON |;

if ($@) {
    print "Loading lib/JSON.pm failed. No B module?\n";
    print "perl says : $@";
    print "Setting environmental variable 'PERL_DL_NONLAZY' to 0 may help.\n";
    print "No Makefile created.\n";
    exit 0;
}


my $version     = JSON->VERSION;

print <<EOF;
Welcome to JSON (v.$version)
=============================

 ** BACKWARD INCOMPATIBILITY **

Since version 2.90, stringification (and string comparison) for
JSON::true and JSON::false has not been overloaded. It shouldn't
matter as long as you treat them as boolean values, but a code that
expects they are stringified as "true" or "false" doesn't work as
you have expected any more.

    if (JSON::true eq 'true') {  # now fails

    print "The result is $JSON::true now."; # => The result is 1 now.

And now these boolean values don't inherit JSON::Boolean, either.
When you need to test a value is a JSON boolean value or not, use
JSON::is_bool function, instead of testing the value inherits
a particular boolean class or not.

EOF


WriteMakefile(
    'NAME'          => 'JSON',
    'VERSION_FROM'  => 'lib/JSON.pm', # finds $VERSION
    'ABSTRACT_FROM' => 'lib/JSON.pm', # retrieve abstract from module
    'AUTHOR' => 'Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt>',
    'PREREQ_PM'     => {
              'Test::More'  => 0,
    },
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'perl', ) : () ),

    ( $ExtUtils::MakeMaker::VERSION >= 6.46 ? (
        'META_MERGE' => {
            resources => {
                repository  =>      'https://github.com/makamaka/JSON',
                bugtracker  =>      'https://github.com/makamaka/JSON/issues',
            },
            recommends => {
                'JSON::XS' => JSON->require_xs_version,
            },
        } ) : ()
    ),
);


if ($] < 5.006) { # I saw to http://d.hatena.ne.jp/asakusabashi/20051231/p1 
    open(IN, "Makefile");
    open(OUT,">Makefile.tmp") || die;
    while(<IN>) {
        s/PERL_DL_NONLAZY=1//g;
        print OUT;
    }
    close(OUT);
    close(IN);
    rename("Makefile.tmp" => "Makefile");
}
