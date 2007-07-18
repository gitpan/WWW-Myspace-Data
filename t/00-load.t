#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::Myspace::Data' );
}

diag( "Testing WWW::Myspace::Data $WWW::Myspace::Data::VERSION, Perl $], $^X" );
