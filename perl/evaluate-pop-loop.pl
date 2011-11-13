#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use CouchDB::Client;
use Algorithm::Evolutionary::Simple qw(random_chromosome max_ones);
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

my $doc = $db->newDesignDoc('_design/rev')->retrieve;
my $view = $doc->queryView( "rev1", startkey => 0,
			      limit=> $population_size );

my $best_so_far = { data =>{ fitness => 0}}; # Dummy for comparisons

my $rev = $db->newDesignDoc('_design/rev')->retrieve;
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
  print "Evaluated ".scalar(@$response)
    ." chromosomes; best so far $best_so_far->{'id'} => $best_so_far->{'data'}{'fitness'} \n";
  #  print encode_json( $response );
  
  $view = $doc->queryView( "rev1", startkey => 0,
			   limit=> $population_size );
  if (  !@{$view->{'rows'}} ) {
    sleep 1;
    print "Sleeping \n";
    $view = $doc->queryView( "rev1", startkey => 0,
			     limit=> $population_size ); # What a hack
    next;
  }
  $evals_so_far = $evaluations->queryView('count')->{'rows'}->[0]{'value'} ; #Reeval how many
} 

print "\n\tFinished after $evals_so_far evaluations\n";


#-----------------------------

