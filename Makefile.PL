use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Mojolicious::Plugin::HTMLLint',
    VERSION_FROM => 'lib/Mojolicious/Plugin/HTMLLint.pm',
    AUTHOR       => 'Viktor Turskyi <koorchik@cpan.org>',
    PREREQ_PM    => {
        'Mojolicious' => '2.88',
        'HTML::Lint'  => 0
    },
    test => { TESTS => 't/*.t' },
    dist      => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', }
);
