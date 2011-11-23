#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
 /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib);

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

my $view = $db->listDocs();
my @all_docs;
for my $p ( @{$view} ) {
  if ( $p->{'id'} !~ /_design/ ) {
    push @all_docs, $p;
  }
}

my $response = $db->bulkDelete( \@all_docs );
 



#-----------------------------

