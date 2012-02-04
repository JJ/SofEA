#!/usr/bin/perl

use strict;
use warnings;

my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);

my @population_all;
for my $f ( @files_to_process ) {
  my $text= read_file($f);
  my @population = ( $text =~ /population: (\d+)/g) ;
  my @population_acc = ($population[0]);
  for ( my $i = 1; $i <$#population; $i++ ) {
    $population_acc[$i] = $population[$i]+ $population_acc[$i-1] ;
  }
  for ( my $i = 0; $i <$#population; $i++ ) {
    push( @{$population_all[$i]}, $population_acc[$i]);
  }
}
for my $e ( @population_all ) {
  my $total;
  map( $total += $_ , @$e );
  print $total / @$e, "\n";
}

