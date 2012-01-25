#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib 
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
	   /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use Log::YAMLLogger;
use Algorithm::Evolutionary::Simple qw(random_chromosome max_ones);
#use JSON qw(encode_json);
use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "eval-".$sofea_conf ->{'id'};
if ($sofea_conf->{'initial_delay'}) {
  sleep  $sofea_conf->{'initial_delay'};
  print "Delayed $sofea_conf->{'initial_delay'}\n";
}
my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'eval_pop_size'};
my $max_evaluations = $sofea_conf->{'max_evaluations'};

my $doc = $db->newDesignDoc('_design/rev')->retrieve;
my $fraction = 1-$sofea_conf->{'eval_pop_size'}/$sofea_conf->{'base_population'};
my $view = $doc->queryView( "rev1", startkey => rand($fraction),
			    limit=> $population_size ); #could be less, don't care

my $best_so_far = { data => { fitness => 0 }}; # Dummy for comparisons
my $solution_doc = $db->newDoc('solution');  
my $solution_found = { data => { found => 0 }}; # Dummy for comparisons
my $rand ;
do {
  my @updated_docs;
  if (  @{$view->{'rows'}} ) {
    for my $p ( @{$view->{'rows'}} ) {
      $p->{'value'}->{'fitness'} = max_ones( $p->{'value'}{'str'});
      my $new_guy = $db->newDoc( $p->{'value'}{'_id'},
				 $p->{'value'}{'_rev'}, 
				 $p->{'value'} );
      push @updated_docs, $new_guy;
      if ( $new_guy->{'data'}{'fitness'} > $best_so_far->{'data'}{'fitness'} ) {
	$best_so_far = $new_guy;
      }
      if ( $new_guy->{'data'}{'fitness'}  >= $sofea_conf->{'chromosome_length'}  ) {
	print "Solution found \n\n";
	$solution_found = $solution_doc->retrieve;
	$solution_found->{'data'}->{'found'} = $new_guy->{'data'};
	$solution_found->update;
      }
      
    }
    my $response = $db->bulkStore( \@updated_docs );
    my $conflicts = 0; 
    map( (defined $_->{'error'})?$conflicts++:undef, @$response );
    $logger->log( { Evaluated  => scalar(@$response),
		    Best =>  $best_so_far->{'id'},
		    Fitness => $best_so_far->{'data'}{'fitness'},
		    Conflicts => $conflicts,
		    Rand => $rand} );
  } else  {
    sleep 1;
    $logger->log( "Sleeping" );
  }
  if ( $solution_found->{'data'}->{'found'} == 0 ) {
    $rand = rand($fraction);
    $view = $doc->queryView( "rev1", startkey => $rand,
			     limit=> $population_size );

    eval {
      $solution_found = $solution_doc->retrieve;
    };
  }
} until ($solution_found->{'data'}->{'found'} ne '0' );

$logger->close;
print "End Evaluator\n";

#-----------------------------

