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
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $!\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "repro-".$sofea_conf ->{'id'};

my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'repro_pop_size'};
my $max_evaluations = $sofea_conf->{'max_evaluations'};

#Create design docs
my $rev = $db->newDesignDoc('_design/rev')->retrieve;
my $fraction = 1-$sofea_conf->{'repro_pop_size'}/$sofea_conf->{'initial_population'};
my $by = $db->newDesignDoc('_design/by')->retrieve;
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $sleep = shift || 1;
my $total_conflicts;

my $best_so_far='';
my $best_fitness = 0;
my $solution_doc = $db->newDoc('solution');  
my $solution_found = { data => { found => 0 }}; # Dummy for comparisons
my $conflicts_old = 0;
do {
  my $view = $rev->queryView( "rev1", 
			      startkey=> rand($fraction),
			      limit=> $population_size + $conflicts_old);

  my @population;
  my %fitness_of;
  my %old_guys;
 
  for my $p ( @{$view->{'rows'}} ) {
    $old_guys{ $p->{'id'} } = $p->{'value'};
    push( @population, $p->{'id'});
    $fitness_of{ $p->{'id'} } =  $p->{'value'}{'fitness'};
  }
    
  my @old_guys_sorted = nkeysort { $fitness_of{ $_ }} @population;
  my @new_docs;
  my $new_guy;
  if ( @population > $population_size )  {
    my @excess_old_guys = splice( @old_guys_sorted, 0, @population-$population_size); # Trim the fat
 
    for my $e (@excess_old_guys ) {
      $new_guy= $db->newDoc($e,  
			    $old_guys{$e}->{'_rev'}, 
			    { str => $e,
			      fitness => $fitness_of{$e}});
      push @new_docs, $new_guy;
    }
  }
  
  my @pool = get_pool_roulette_wheel( \@old_guys_sorted, \%fitness_of, $population_size );
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
  } while (  @new_guys_sorted 
	     and @old_guys_sorted 
	     and ($fitness_of{$new_guys_sorted[$#new_guys_sorted]} > $fitness_of{ $old_guys_sorted[0] }) );
  
  my $response = $db->bulkStore( \@new_docs );
  $conflicts_old = 0; 
  my $conflicts_new = 0;
  for my $r (@$response ) {
    if  (defined $r->{'error'}) {
      if (defined $old_guys{$r->{'id'}}) {
	$conflicts_old ++;
      } else {
	$conflicts_new++;
      }
    }
  }
  $logger->log( { conflicts_old => $conflicts_old,
		  conflicts_new => $conflicts_new,
		  population => scalar @new_population,
		  best => $best_so_far,
		  fitness => $best_fitness,
		total_population => $view->{'total_rows'}} );
  $total_conflicts += $conflicts_old + $conflicts_new;
  my $solution_doc = $db->newDoc('solution');  
  eval {
    $solution_found = $solution_doc->retrieve;
  };
} until ($solution_found->{'data'}->{'found'} ne '0');
$logger->log( {Finished => $total_conflicts}, 1);
$logger->close;
print "End Reproducer\n";

#-----------------------------

