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

my $doc = $db->newDesignDoc('_design/rev')->retrieve;
my $view = $doc->queryView( "rev1", startkey => 0,
			      limit=> $population_size );

my $best_so_far = { fitness => 0}; # Dummy for comparisons
while (  @{$view->{'rows'}} ) {
 
  my @updated_docs;
  for my $p ( @{$view->{'rows'}} ) {
    my $new_guy = $db->newDoc( $p->{'value'}{'_id'},
			       $p->{'value'}{'_rev'}, 
			       { fitness => max_ones( $p->{'value'}{'str'})} );
    push @updated_docs, $new_guy;
    if ( $new_guy->{'fitness'} > $best_so_far->{'fitness'} ) {
      $best_so_far = $new_guy;
    }
    
  }
  my $response = $db->bulkStore( \@updated_docs );
  
#  print encode_json( $response );
  
  $view = $doc->queryView( "rev1", startkey => 0,
			   limit=> $population_size );

} 




#-----------------------------

