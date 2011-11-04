#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use CouchDB::Client;
use Algorithm::Evolutionary::Simple qw(random_chromosome);

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


my $chromosome_length = shift || 16;
my $population_size = shift || 32;

print<<EOC;
CL $chromosome_length
PS $population_size
EOC

my @population = map( random_chromosome( $chromosome_length ), 
		      1..$population_size );

for my $p (@population) {
  next  if ( $db->docExists( $p ) ) ;
  my $sofa_doc = { str => $p,
		   rnd => rand() };
  my $doc = $db->newDoc( $p, undef, $sofa_doc )->create;
  print "Inserted with id $p\n";
}
