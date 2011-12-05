#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib/  
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
/home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib  );

use YAML qw(LoadFile Dump); 
use Log::YAMLLogger;
use Algorithm::Evolutionary::Simple qw( get_pool_roulette_wheel produce_offspring );
use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "repro-".$sofea_conf ->{'id'};

my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'repro_pop_size'};
my $max_evaluations = $sofea_conf->{'max_evaluations'};

#Create design docs
my $rev = $db->newDesignDoc('_design/rev')->retrieve;
my $by = $db->newDesignDoc('_design/by')->retrieve;
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $sleep = shift || 1;
my $best_so_far = $by->queryView('fitness', limit => 1,
				 descending => 'true' )->{'rows'}->[0]{'value'} ;
my $evals_so_far;
$best_so_far->{'fitness'} = $best_so_far->{'fitness'} || 0;
while ( $best_so_far->{'fitness'} < $sofea_conf->{'chromosome_length'} ) {
  my $view = $rev->queryView( "rev2", 
			      startkey=> rand(),
			      limit=> $population_size );

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
  $best_so_far = $by->queryView('fitness', limit => 1)->{'rows'}->[0]{'value'} ; #Reeval how many
  $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ; #Reeval how many
  $logger->log( { Evaluations => $evals_so_far,
		  Best => $best_so_far,
		  conflicts => $conflicts} ); 
}
$logger->log( {Finished => $evals_so_far}, 1);
$logger->close;

#-----------------------------

