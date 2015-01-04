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
use Sort::Key::Top qw(rnkeytopsort);

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "repro-".$sofea_conf ->{'id'};

my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'repro_pop_size'};
my $gen_to_migration = $sofea_conf->{'gen_to_migration'}|| 10;
my $pool = $sofea_conf->{'pool'} || '';
my $get_pool;
if ( $pool eq "roulette" ) {
  $get_pool = \&get_pool_roulette_wheel;
}   else {
  $get_pool = \&get_pool_binary_tournament;
}

#Create design docs
my $by = $db->newDesignDoc('_design/by')->retrieve;

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
my $generation = 0;
do {

  my $this_population_size = scalar @population;
  my @pool = $get_pool->( \@population, \%fitness_of, $this_population_size );
  my @new_population  = produce_offspring( \@pool, $this_population_size );
  
  for my $p (@new_population ) {
    
    $fitness_of{$p} = $fitness_of{$p} || max_ones($p) ;
    if ( $fitness_of{$p} > $best_fitness ) {
	$best_so_far = $p;
	$best_fitness = $fitness_of{$p};
      }
    
    if ( $fitness_of{$p}  >= $sofea_conf->{'chromosome_length'}  ) {
      print "Solution found \n\n";
      $solution_found = $solution_doc->retrieve;
      my $new_guy = $db->newDoc($p,  undef, { fitness => $fitness_of{$p} }); 
      $solution_found->{'data'}->{'found'} = $new_guy->{'data'};
      $solution_found->update;
    }
  }

  $logger->log( { best => $best_so_far,
		  fitness => $best_fitness,
		  generation => $generation} );
  
  my $solution_doc = $db->newDoc('solution');  
  eval {
    $solution_found = $solution_doc->retrieve;
  };
  if (($generation % $gen_to_migration == 0 ) 
      && ( $solution_found->{'data'}->{'found'} eq '0' ) ) {
    #Make request and put it into the population
    my $view = $by->queryView( "fitness_null", 
			       limit=> $population_size,
			       descending => 'true' );
    for my $p ( @{$view->{'rows'}} ) {
      $fitness_of{ $p->{'id'} } =  $p->{'key'};
    }
    
  }
  @population = 
      rnkeytopsort { $fitness_of{ $_} } $sofea_conf->{'initial_population'}
	=> keys %fitness_of;

  if (($generation % $gen_to_migration == 0 ) 
      && ( $solution_found->{'data'}->{'found'} eq '0' ) ) {
    my @new_docs;
    for my $p (@population[0..$population_size] ) {
      my  $new_guy= $db->newDoc($p,  undef, {fitness => $fitness_of{$p} }) ;
      push @new_docs, $new_guy;
    }
    $db->bulkStore( \@new_docs );
  }
  $generation++;
} until ($solution_found->{'data'}->{'found'} ne '0');
$logger->log( {generation => $generation}, 1);
$logger->close;
print "End Reproducer\n";

#-----------------------------

