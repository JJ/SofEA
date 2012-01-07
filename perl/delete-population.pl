#!/usr/bin/perl

use strict;
use warnings;

use lib qw(/home/jmerelo/progs/SimplEA/trunk/Algorithm-Evolutionary-Simple/lib
 /home/jmerelo/progs/SimplEA/Algorithm-Evolutionary-Simple/lib);

use My::Couch;

my $cdb_conf_file = shift || 'conf';
my $c = new My::Couch( "$cdb_conf_file.yaml" ) || die "Can't load: $@\n";
my $db = $c->db;

my $view = $db->listDocs();
my @all_docs;
for my $p ( @{$view} ) {
  if ( $p->{'id'} !~ /_design/ ) {
    push @all_docs, $p;
  }
}

my $response = $db->bulkDelete( \@all_docs );
$db->newDoc( 'evaluations', undef, { evals => 0} )->create;
$db->newDoc( 'solution', undef, { found => 0} )->create;
print "Deleted\n";

#-----------------------------

