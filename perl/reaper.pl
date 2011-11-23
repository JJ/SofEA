#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
 /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib);

use YAML qw(LoadFile Dump); 
use Log::YAMLLogger;
use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "reaper-".$sofea_conf ->{'id'};

my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'base_population'};
my $max_evaluations = $sofea_conf->{'max_evaluations'};

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
  $logger->log( { Deleted => scalar(@$response) } );
}

$logger->log( { Finished => $evals_so_far}, 1 );
$logger->close;

