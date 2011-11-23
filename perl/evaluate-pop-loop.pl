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

my $logger = new Log::YAMLLogger $sofea_conf;

my $population_size = $sofea_conf->{'eval_pop_size'};
my $max_evaluations = $sofea_conf->{'max_evaluations'};

my $doc = $db->newDesignDoc('_design/rev')->retrieve;
my $view = $doc->queryView( "rev1", startkey => rand(),
			    limit=> $population_size ); #could be less, don't care

my $best_so_far = { data =>{ fitness => 0}}; # Dummy for comparisons

my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ;

while ( $evals_so_far < $max_evaluations ) { 
  my @updated_docs;
  for my $p ( @{$view->{'rows'}} ) {
    $p->{'value'}->{'fitness'} = max_ones( $p->{'value'}{'str'});
    my $new_guy = $db->newDoc( $p->{'value'}{'_id'},
			       $p->{'value'}{'_rev'}, 
			       $p->{'value'} );
    push @updated_docs, $new_guy;
    if ( $new_guy->{'data'}{'fitness'} > $best_so_far->{'data'}{'fitness'} ) {
      $best_so_far = $new_guy;
    }
    
  }
  my $response = $db->bulkStore( \@updated_docs );
  $logger->log( { Evaluated  => scalar(@$response),
		Best =>  $best_so_far->{'id'},
		Fitness => $best_so_far->{'data'}{'fitness'} } );
  $view = $doc->queryView( "rev1", startkey => rand(),
			   limit=> $population_size );
  if (  !@{$view->{'rows'}} ) {
    sleep 1;
    $logger->log( "Sleeping" );
    $view = $doc->queryView( "rev1", startkey => 0,
			     limit=> $population_size ); # What a hack
    next;
  }
  $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ; #Reeval how many
} 

$logger->log( {Finished => $evals_so_far} );
$logger->close;


#-----------------------------

