#!/usr/bin/perl

use strict;
use warnings;

=head2 SYNOPSIS

This is a sample script to get you started using WWW::Myspace::FriendAdder.
Copy this friend_adder.pl & adder.cfg to a new directory and edit them as it 
suits you.  A lot of the parameters have been set up for you based on how I 
like to use the script.  Your mileage may vary!

=cut

use Data::Dumper;
use WWW::Myspace;
use WWW::Myspace::FriendAdder;

# Don't log in immediately.  This allows us to set a custom mech agent before
# trying to load any pages
my $myspace = WWW::Myspace->new ( 
    auto_login      => 0, 
    account_name    => 'user@email.com', 
    password        => 'seekrit', 
);

$myspace->mech_params({
    agent => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.1) Gecko/20060601 Firefox/2.0.0.1 (Ubuntu-edgy)',
});

# set the mech agent
$myspace->_new_mech;

# now let's try to log in
$myspace->site_login;

# we'll use the config file for our startup params
my %params = (
    config_file         => 'adder.cfg', 
    config_file_format  => 'CFG',
);

# create a new FriendAdder object
my $adder = WWW::Myspace::FriendAdder->new( $myspace, \%params );
my $data  = $adder->get_data_object();

# poach a list of friends that we think will like us
my $friend_url  = 'dixiechicks';
my $friend_id   = $myspace->friend_id( $friend_url ) || die;

# Setting "refresh" to 1 will force a new lookup of friends when the script
# is run.  Otherwise it will just work off the list of friends already in the
# database

# "limit" and "offset" are SQL constraints that will work as you would expect

# results are sorted on friend_id

my @friends = $data->friends_from_profile( { 
    friend_id => $friend_id,  
    #limit => 100,
    #offset => 200,
    order_direction => 'DESC',
    #refresh => 1, 
});

my $size = scalar @friends;
print "$size friends found\n";

# starting sending friend requests
my $report = $adder->add_to_friends( @friends );

# Dump out the results. 
print Dumper( $report );