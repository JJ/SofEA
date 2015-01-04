#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
	   /home/jmerelo/proyectos/CPAN/Algorithm-Evolutionary/lib/
	   /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib );

use YAML qw(LoadFile Dump); 
use CouchDB::Client;
use Algorithm::Evolutionary::Simple qw(random_chromosome);
use Algorithm::Evolutionary::Fitness::P_Peaks;
use My::Couch;

my $cdb_conff = shift || 'conf';
my $c = new My::Couch( "$cdb_conff.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conff = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conff.yaml") || die "Can't load $sofea_conff: $!\n";
my $peaks = $sofea_conf->{'peaks'};
my $bits = $sofea_conf->{'chromosome_length'};
my $p_peaks = new  Algorithm::Evolutionary::Fitness::P_Peaks( $peaks, $bits );
my $population_size = $sofea_conf->{'initial_population'};

print<<EOC;
CL $bits
PS $population_size
EOC

my @population = map( random_chromosome( $bits ), 
		      1..$population_size );

my @docs;
for my $p (@population) {
  my $sofa_doc = { str => $p,
		   rnd => rand(),
		   fitness => $p_peaks->p_peaks( $p) };
  push @docs, $db->newDoc( $p, undef, $sofa_doc );
}

my $response = $db->bulkStore( \@docs );
print "Inserted ".scalar(@$response)." chromosomes \n";
