#!perl 

use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 29;

use lib 't';
require_ok( 'WWW::Myspace' );
require_ok( 'WWW::Myspace::Data' );

my $data = WWW::Myspace::Data->new();
 
isa_ok($data, 'WWW::Myspace::Data');
can_ok( $data, 'approve_friend_requests');
can_ok( $data, 'is_band');
can_ok( $data, 'is_band_from_cache');
can_ok( $data, 'is_cached' );
can_ok( $data, 'is_invalid');
can_ok( $data, 'is_private');
can_ok( $data, 'loader' );
can_ok( $data, 'post_comment');
can_ok( $data, 'send_message');
can_ok( $data, 'set_account' );
can_ok( $data, 'track_friend' );
can_ok( $data, 'update_all_friends' );
can_ok( $data, 'update_friend' );

my $dt1 = $data->_fresh_after({ hours => 1});
isa_ok($dt1, 'DateTime');

my $dt2 = $data->_fresh_after({ hours => 2});

cmp_ok($data->_is_fresh( $dt1, $dt2 ), '==', 1, 'data is fresh');
cmp_ok($data->_is_fresh( $dt2, $dt1 ), '==', -1, 'data is not fresh');

SKIP: {
    skip 'no config file for testing', 10 unless -e 't/friend_adder.cfg';

    my %params = (
        config_file => 't/friend_adder.cfg',
        config_file_format => 'CFG',
    );
    
    require_ok('Config::General');
    my $conf = new Config::General("$params{'config_file'}");
    my %config = $conf->getall;
    
    my $myspace = WWW::Myspace->new( auto_login => 0, human => $config{'human'} || 1 );
    
    my $data = WWW::Myspace::Data->new($myspace, { db => $config{'db'} } );
    my $loader = $data->loader;
    
    my $valid_id = 211075;
    $data->cache_friend( $valid_id );
    cmp_ok ( $data->is_private( $valid_id ), '==', 0, "this is not a private account");
    
    #my $friend_id = $myspace->friend_id('vilerichard');
    #ok( $data->cache_friend( page => $myspace->current_page), "cached friend from page: $friend_id");

    my $friend_url = 'vilerichard';
    my $friend_id = $myspace->friend_id( $friend_url ) || die $myspace->error;
    
    ok( $friend_id, "got friend_id");
    
    ok( $data->cache_friend( $friend_id ), 'friend cached');
    my $tracking = $data->track_friend( $friend_id );
    ok( $tracking->profile_views, 'got ' . $tracking->profile_views . ' profile views ');
    
    #$friend_id = $myspace->friend_id('vilerichard');
    #ok( $data->cache_friend( page => $myspace->current_page), "cached friend from page: $friend_id");
    
    $tracking = $data->track_friend( page => $myspace->current_page );
    ok( $tracking->profile_views, 'got profile views from page');
    
    ok ( $data->is_band( $friend_id), "this is a band profile");
    ok ( !$data->is_private( $friend_id), "this is account is not set to private");
    ok ( !$data->is_private( $friend_id), "this is not an invalid account");

    my $invalid_id = 18264230;
    $data->cache_friend( $invalid_id );
    ok ( $data->is_invalid( $invalid_id ), "this is not a valid account");

}
