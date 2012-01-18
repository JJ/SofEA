#!/usr/bin/perl 

use strict;
use warnings;

use AnyEvent::CouchDB::Stream;
use YAML qw(Dump);

my $listener = AnyEvent::CouchDB::Stream->new(
					      url       => 'http://localhost:5984',
					      database  => 'sofea_test',
					      on_change => sub {
						my $change = shift;
						print Dump $change;
					      },
					      on_keepalive => sub {
						print "ping\n";
					      },
					      timeout => 10,
					     );

 # However, you have to be in an event loop at some point in time.
AnyEvent->condvar->recv;
