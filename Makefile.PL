use strict;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my $mm_ver = $ExtUtils::MakeMaker::Version;

WriteMakefile(
    'NAME'		=> 'List::Priority',
    'VERSION_FROM'	=> 'Priority.pm', # finds $VERSION
    'PREREQ_PM'		=> {
        'Exporter'   => 0,
        'strict'     => 0,
        'warnings'   => 0,
        'Test::More' => 0.88,
    },

   ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
     (ABSTRACT_FROM => 'Priority.pm', # retrieve abstract from module
      AUTHOR     => 'Miles Gould <miles@assyrian.org.uk>') 
     : ()
   ),

   ($mm_ver <= 6.31
       ? (LICENSE => 'gpl')
       : ()
   ),

   ($mm_ver <= 6.45
       ? (META_MERGE => {
            'meta-spec' => { version => 2},
            resources => {
               bugtracker => '',
               repository => {
                  type => 'git',
                  web  => 'https://github.com/pozorvlak/List-Priority',
                  url  => 'git://github.com/pozorvlak/List-Priority.git',
               },
            },
          })
       : ()
   ),
);
