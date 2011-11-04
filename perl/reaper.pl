#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use CouchDB::Client;
use JSON qw(encode_json);

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

my $by = $db->newDesignDoc('_design/by')->retrieve;
my $by_fitness = $by->queryView( "fitness" );

my @graveyard;
my $all_of_them = scalar @{$by_fitness->{'rows'}} ;
for ( my $r = 0; $r < $all_of_them - $population_size; $r++ ) {
  my $will_die = shift @{$by_fitness->{'rows'}};
  push @graveyard, $db->newDoc( $will_die->{'id'}, $will_die->{'value'}{'_rev'}, undef) ; #deleted
}
my $response = $db->bulkStore( \@graveyard );
  
  print encode_json( $response );
