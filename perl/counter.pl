#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
	   /home/jmerelo/progs/logyaml/trunk/Log-YAMLLogger/lib 
 /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib);

use YAML qw(LoadFile Dump); 
use Log::YAMLLogger;
use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $sofea_conf_file = shift || 'base';
my $sofea_conf = LoadFile("$sofea_conf_file.yaml") || die "Can't load $sofea_conf_file: $!\n";
$sofea_conf ->{'id'} = "reaper-".$sofea_conf ->{'id'};

my $max_evaluations = $sofea_conf->{'max_evaluations'};

my $evaluations = $db->newDesignDoc('_design/docs')->retrieve;
my $all_docs = $evaluations->queryView('count', reduce => 'false')->{'rows'} ; #Reeval how many
my $evals_so_far = @$all_docs -1 ;
while ( $evals_so_far < $max_evaluations ) {
  $all_docs = $evaluations->queryView('count', reduce => 'false')->{'rows'} ; #Reeval how many
  $evals_so_far = @$all_docs -1 ; # Minus one for "evaluations";
  print "Evals: $evals_so_far";
  my $eval_doc = new CouchDB::Client::Doc ( { db => $db,
					   id => 'evaluations' } )->retrieve;
  $eval_doc->{'data'}->{'evals'}  = $evals_so_far;
  $eval_doc->update;
}

