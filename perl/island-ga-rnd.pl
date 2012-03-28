#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib/  
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
/home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib  );

use YAML qw(LoadFile Dump); 
use Log::YAMLLogger;
use Algorithm::Evolutionary::Simple qw( get_pool_roulette_wheel random_chromosome
					get_pool_binary_tournament
					produce_offspring max_ones );
use My::Couch;
use Sort::Key::Top qw(nkeytop);

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "repro-".$sofea_conf ->{'id'};

my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'repro_pop_size'};
my $pool = $sofea_conf->{'pool'} || '';
my $get_pool;
if ( $pool eq "roulette" ) {
  $get_pool = \&get_pool_roulette_wheel;
}   else {
  $get_pool = \&get_pool_binary_tournament;
}

#Create design docs
my $by = $db->newDesignDoc('_design/by')->retrieve;
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $sleep = shift || 1;
my $total_conflicts;

my $best_so_far='';
my $best_fitness = 0;
my $solution_doc = $db->newDoc('solution');  
my $solution_found = { data => { found => 0 }}; # Dummy for comparisons
my @population;
my %fitness_of;
for (my $i = 0; $i < $sofea_conf->{'initial_population'}; $i++) {
  $population[$i] = random_chromosome( $sofea_conf->{'chromosome_length'});
  $fitness_of{$population[$i]} = max_ones( $population[$i] );
}

#Start EA
do {

  my $this_population_size = scalar @population;
  my $fitness_of_worst = 0;
  my @pool = $get_pool->( \@population, \%fitness_of, $this_population_size );
  my @new_population  = produce_offspring( \@pool, $this_population_size );
  
  my %new_guys;
  my @new_docs;
  for my $p (@new_population ) {
    
    my $fitness = max_ones($p) ;
    if ( $fitness > $best_fitness ) {
	$best_so_far = $p;
	$best_fitness = $fitness;
      }
    $fitness_of{ $p } = $new_guys{$p} = $fitness;
    
    if ( $fitness  >= $sofea_conf->{'chromosome_length'}  ) {
      print "Solution found \n\n";
      $solution_found = $solution_doc->retrieve;
      my $new_guy = $db->newDoc($p,  undef, { fitness => $fitness }) ;
      $solution_found->{'data'}->{'found'} = $new_guy->{'data'};
      $solution_found->update;
    }
    if ( $fitness > $fitness_of_worst ) {
      my  $new_guy= $db->newDoc($p,  undef, {fitness => $fitness }) ;
      push @new_docs, $new_guy;
    }
    
  }

  my $response = $db->bulkStore( \@new_docs );
  my $conflicts = 0; 
  map( (defined $_->{'error'})?$conflicts++:undef, @$response );
  $logger->log( { conflicts => $conflicts,
		  population => scalar @population,
		  best => $best_so_far,
		  fitness => $best_fitness,
		  new_docs => scalar( @new_docs )} );
  $total_conflicts += $conflicts;

  my $solution_doc = $db->newDoc('solution');  
  eval {
    $solution_found = $solution_doc->retrieve;
  };
  if ($solution_found->{'data'}->{'found'} eq '0' ) {
    #Make request and put it into the population
    my $view = $by->queryView( "fitness_null", 
			       limit=> int($population_size/(1+rand(3))),
			       descending => 'true' );
    
    for my $p ( @{$view->{'rows'}} ) {
      push( @population, $p->{'id'});
      $fitness_of{ $p->{'id'} } =  $p->{'key'};
    }
    
    @population = 
      nkeytop { $fitness_of{ $_} } -$sofea_conf->{'initial_population'}
	=> keys %fitness_of;
  }
} until ($solution_found->{'data'}->{'found'} ne '0');
$logger->log( {Finished => $total_conflicts}, 1);
$logger->close;
print "End Reproducer\n";

#-----------------------------

