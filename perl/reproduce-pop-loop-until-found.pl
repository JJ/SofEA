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
my $total_conflicts;
my $solution_found;

do {
  my $view = $rev->queryView( "rev2", 
			      startkey=> rand(),
			      limit=> $population_size );

  my @population;
  my %fitness_of;
  if ( !@{$view->{'rows'}}  )  {
    sleep $sleep;
     $logger->log( "Sleeping" );
  } else {

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
    $logger->log( { conflicts => $conflicts} );
    $total_conflicts += $conflicts;
  }
  my $solution_doc = $db->newDoc('solution');  
  eval {
    $solution_found = $solution_doc->retrieve;
  };
} until ($solution_found->{'data'}->{'found'} ne '0');
$logger->log( {Finished => $total_conflicts}, 1);
$logger->close;
print "End Reproducer\n";

#-----------------------------

