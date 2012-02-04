#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
 /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib);

use YAML qw(LoadFile Dump); 
use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "repro-".$sofea_conf ->{'id'};
my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;

my $document_count = $evaluations->queryView('all',
					    group=> 'true',
					    group_level => '1' )->{'rows'} ;
my $evals_so_far;
do {
  print $document_count->[0]->{'value'},";",$document_count->[1]->{'value'},";",$document_count->[2]->{'value'},"\n";
  $document_count = $evaluations->queryView('all',
					    group=> 'true',
					    group_level => '1' )->{'rows'} ;
  $evals_so_far = $document_count->[1]->{'value'}+$document_count->[2]->{'value'};
  sleep 1;
} while ( $evals_so_far < $sofea_conf->{'max_evaluations'} );


