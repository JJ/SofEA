#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use CouchDB::Client;
use Algorithm::Evolutionary::Simple qw(random_chromosome max_ones);
use JSON qw(encode_json);
use LWP::UserAgent;

my $conf = LoadFile('conf.yaml') || die "No puedo cargar la configuracion : $!\n";
my $c = CouchDB::Client->new(uri => $conf->{'couchurl'});
$c->testConnection or die "The server cannot be reached";
print "Running version " . $c->serverInfo->{version} . "\n";
my $db;
eval {
  $db = $c->newDB($conf->{'couchdb'})->create;
};
if ( $@ ) {
  $db = $c->newDB($conf->{'couchdb'});
}
print "Connected to $conf->{'couchdb'}\n";

my $population_size = shift || 32;
my $doc = $db->newDesignDoc('_design/rev')->retrieve;
my $view = $doc->queryView( "rev1", limit=> $population_size );

my $docs = { docs => []};
for my $p ( @{$view->{'rows'}} ) {
  push @{$docs->{'docs'}}, { _id => $p->{'value'}{'_id'}, 
			     _rev => $p->{'value'}{'_rev'},
			     fitness => max_ones( $p->{'value'}{'str'})};
}

 my $ua = LWP::UserAgent->new;
$ua->agent("MyApp/0.1 ");
my $req = HTTP::Request->new(POST => "$conf->{'couchurl'}/$conf->{'couchdb'}/_bulk_docs");
$req->content_type('application/json');
$req->content(encode_json($docs));
# Pass request to the user agent and get a response back
my $res = $ua->request($req);

# Check the outcome of the response
if ($res->is_success) {
  print $res->content;
}
else {
  print $res->status_line, "\n";
}



#-----------------------------

