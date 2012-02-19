#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib/  
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
/home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib  );

use YAML qw(LoadFile Dump); 
use Log::YAMLLogger;
use Algorithm::Evolutionary::Simple qw( get_pool_roulette_wheel produce_offspring max_ones );
use My::Couch;
use Sort::Key qw(nkeysort );

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
my $fraction = 1-$sofea_conf->{'repro_pop_size'}/$sofea_conf->{'base_population'};
my $by = $db->newDesignDoc('_design/by')->retrieve;
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $sleep = shift || 1;
my $total_conflicts;

my $best_so_far='';
my $best_fitness = 0;
my $solution_doc = $db->newDoc('solution');  
my $solution_found = { data => { found => 0 }}; # Dummy for comparisons
do {
  my $view = $rev->queryView( "rev1", 
			      startkey=> rand($fraction),
			      limit=> $population_size );

  my @population;
  my %fitness_of;
  if ( !@{$view->{'rows'}}  )  {
    sleep $sleep;
    $logger->log( "Sleeping" );
  } else {
    
    my %old_guys;
    for my $p ( @{$view->{'rows'}} ) {
      $old_guys{ $p->{'id'} } = $p->{'value'};
      push( @population, $p->{'id'});
      $fitness_of{ $p->{'id'} } =  $p->{'value'}{'fitness'};
    }
    
    my @pool = get_pool_roulette_wheel( \@population, \%fitness_of, $population_size );
    my @new_population  = produce_offspring( \@pool, $population_size );
    
    for my $p (@new_population ) {

      my $fitness = max_ones($p) ;
      if ( $fitness > $best_fitness ) {
	$best_so_far = $p;
	$best_fitness = $fitness;
      }
      $fitness_of{ $p } =  $fitness;

      if ( $fitness  >= $sofea_conf->{'chromosome_length'}  ) {
	 print "Solution found \n\n";
	 $solution_found = $solution_doc->retrieve;
	 my $new_guy = $db->newDoc($p,  undef, { str => $p, 
						 rnd => rand(),
						 fitness => $fitness }) ;
	 $solution_found->{'data'}->{'found'} = $new_guy->{'data'};
	 $solution_found->update;
      }

    }

    my @new_guys_sorted =  nkeysort { $fitness_of{ $_} }  @new_population;
    my @old_guys_sorted = nkeysort { $fitness_of{ $_ }} @population;
    my @new_docs;
    #Add one for every one eliminated, until they are not better.
    do {
      my $t = pop @new_guys_sorted;
      my 	$new_guy= $db->newDoc($t,  undef, { str => $t, 
						    rnd => rand(),
						fitness => $fitness_of{$t} }) ;
      push @new_docs, $new_guy;
      my $b = shift @old_guys_sorted;
      $new_guy= $db->newDoc($b,  
			    $old_guys{$b}->{'_rev'}, 
			    { str => $b,
			      fitness => $fitness_of{$b}});
      push @new_docs, $new_guy;
      last if !@new_guys_sorted;
      last if !@old_guys_sorted;
    } while ( $fitness_of{$new_guys_sorted[$#new_guys_sorted]} > $fitness_of{ $old_guys_sorted[0] } );

    my $response = $db->bulkStore( \@new_docs );
    my $conflicts = 0; 
    map( (defined $_->{'error'})?$conflicts++:undef, @$response );
    $logger->log( { conflicts => $conflicts,
		    population => scalar @population,
		    best => $best_so_far,
		    fitness => $best_fitness} );
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

