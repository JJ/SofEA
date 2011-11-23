#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
 /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib);

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

my $population_size = shift || 128;
my $max_evaluations = shift || 10000;

my $rev = $db->newDesignDoc('_design/rev')->retrieve;
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $sleep = shift || 10;
my $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ;
while ( $evals_so_far < $max_evaluations ) {
  my $view = $rev->queryView( "rev2", limit=> $population_size );
  my $by = $db->newDesignDoc('_design/by')->retrieve;
  my $by_fitness = $by->queryView( "fitness" );

  my @graveyard;
  my $all_of_them = scalar @{$by_fitness->{'rows'}} ;
  if ( $all_of_them < $population_size ) {
    sleep 1;
    next;
  }
  for ( my $r = 0; $r < $all_of_them - $population_size; $r++ ) {
    my $will_die = shift @{$by_fitness->{'rows'}};
    push @graveyard, $db->newDoc( $will_die->{'id'}, $will_die->{'value'}{'_rev'}, $will_die->{'value'}) ; #deleted
  }
  my $response = $db->bulkStore( \@graveyard );
  $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ; #Reeval how many
  print "Deleted ".scalar(@$response)." chromosomes \n";
}

print "\n\tFinished after $evals_so_far evaluations\n";

