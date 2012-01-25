#!/usr/bin/perl 

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib 
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
	   /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib );

use AnyEvent::CouchDB::Stream;
use YAML qw(Dump LoadFile);
use Log::YAMLLogger;
use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "changes-".$sofea_conf ->{'id'};

my $logger = new Log::YAMLLogger $sofea_conf;
my $done = AE::cv;
my $listener = AnyEvent::CouchDB::Stream->new(
					      url       => $c->{'_db'}{'client'}{'uri'},
					      database  => $c->{'_db'}{'name'},
					      on_change => sub {
						my $change = shift;
#						print Dump $change;
						if ($change->{'id'} eq '1'x128 
						   && $change->{'deleted'} ne '1' ) {
						  print "Found\n";
						  $done->send;
						}
						$logger->log( $change );
					      },
					      timeout => 5,
					     );

 # However, you have to be in an event loop at some point in time.
$done->recv;
