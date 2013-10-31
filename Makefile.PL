require 5.00503;
use strict;
use ExtUtils::MakeMaker;

use lib qw( ./lib );

$| = 1;

eval q| require JSON |;

# B module can't install? I'm not careful for such a problem.
# Leave us alone today?
if ($@) {
    print "We try to look up lib/JSON.pm, but in vain. B module can't install?\n";
    print "Set the environmental variable 'PERL_DL_NONLAZY' with 0.\n";
    print "And see to ExtUtils::MM_Unix.\n";
    print "perl says : $@";
    print "We do not make Makefile by requiring Perl version 7.0.\n";
    require 7.0000;
}


my $version     = JSON->VERSION;
my $message;


print <<EOF;
Welcome to JSON (v.$version)
=============================
$message

 *************************** CAUTION **************************************
 *                                                                        *
 * INCOMPATIBLE CHANGE (JSON::XS version 2.90)                            *
 *                                                                        *
 * JSON.pm had patched JSON::XS::Boolean and JSON::PP::Boolean internally *
 * on loading time for making these modules inherit JSON::Boolean.        *
 * But since JSON::XS v3.0 it use Types::Serialiser as boolean class.     *
 * Then now JSON.pm breaks boolean classe overload features and           *
 * -support_by_pp if JSON::XS v3.0 or later is installed.                 *
 *                                                                        *
 * JSON::true and JSON::false returned JSON::Boolean objects.             *
 * For workaround, they return JSON::PP::Boolean objects in this version. *
 *                                                                        *
 *     isa_ok(JSON::true, 'JSON::PP::Boolean');                           *
 *                                                                        *
 * And it discards a feature:                                             *
 *                                                                        *
 *     ok(JSON::true eq 'true');                                          *
 *                                                                        *
 * In other word, JSON::PP::Boolean overload numeric only.                *
 *                                                                        *
 *     ok( JSON::true == 1 );                                             *
 *                                                                        *
 **************************************************************************


 ************************** CAUTION **************************
 * This is 'JSON version 2' and there are many differences   *
 * to version 1.xx                                           *
 * Please check your applications useing old version.        *
 *   See to 'INCOMPATIBLE CHANGES TO OLD VERSION' and 'TIPS' *
 *************************************************************


EOF


WriteMakefile(
    'NAME'          => 'JSON',
    'VERSION_FROM'  => 'lib/JSON.pm', # finds $VERSION
    'PREREQ_PM'     => {
              'Test::More'  => 0,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'lib/JSON.pm', # retrieve abstract from module
       AUTHOR     => 'Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt>') : ()),
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'perl', ) : () ),

    ( $ExtUtils::MakeMaker::VERSION >= 6.46 ? (
        'META_MERGE' => {
            resources => {
                repository  =>      'https://github.com/makamaka/JSON',
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
