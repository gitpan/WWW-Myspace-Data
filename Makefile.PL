use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Myspace::Data',
    AUTHOR              => 'Olaf Alders <olaf#wundersolutions.com>',
    VERSION_FROM        => 'lib/WWW/Myspace/Data.pm',
    ABSTRACT_FROM       => 'lib/WWW/Myspace/Data.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'WWW::Myspace'              => 0.67,
        'Test::More'                => 0,
        'Carp'                      => 0, 
        'Class::DBI'                => 0,
        'Class::DBI::Loader'        => 0,
        'Config::General'           => 0,
        'Data::Dumper'              => 0,
        'DateTime'                  => 0,
        'DateTime::Format::MySQL'   => 0,
        'Class::Factory::Util'      => 1.3, # Data.pm (prereq of above)
        'Params::Validate'          => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Myspace-Data-*' },
);
