#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use CouchDB::Client;
use Algorithm::Evolutionary::Simple qw(random_chromosome max_ones get_pool_roulette_wheel produce_offspring );
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
my $max_evaluations = shift || 10000;

my $rev = $db->newDesignDoc('_design/rev')->retrieve;
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $sleep = shift || 10;
my $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ;
while ( $evals_so_far < $max_evaluations ) {
  my $view = $rev->queryView( "rev2", limit=> $population_size );

  my @population;
  my %fitness_of;
  if ( !@{$view->{'rows'}}  )  {
    sleep $sleep;
    next;
  }

  for my $p ( @{$view->{'rows'}} ) {
    push( @population, $p->{'id'});
    $fitness_of{ $p->{'id'} } =  $p->{'value'}{'fitness'};
  }

  my @pool = get_pool_roulette_wheel( \@population, \%fitness_of, $population_size );
  my @new_population  = produce_offspring( \@pool, $population_size );
  
  my @new_docs = map(  $db->newDoc($_, undef, { str => $_, 
						rnd => rand() } ), @new_population );
  
  my $response = $db->bulkStore( \@new_docs );
  my $conflicts = 0; 
  map( (defined $_->{'error'})?$conflicts++:undef, @$response );
  $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ; #Reeval how many
  print "Evaluations so far: $evals_so_far; conflicts $conflicts\n"; 
}
print "\n\tFinished after $evals_so_far evaluations\n";

#-----------------------------

