#!/usr/bin/perl

use strict;
use warnings;

my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);
my @population_sizes_at_step;
for my $f ( @files_to_process ) {
  my $text= read_file($f);
  my $total_population;
  my (@fitness_population) = ( $text =~ /fitness: (\d+).+?population: (\d+)/gs) ;
  my %fitness_at;
  while (@fitness_population) {
    my ($this_fitness, $this_pop ) = splice( @fitness_population,  0, 2 );
    $total_population += $this_pop;
    $fitness_at{$this_fitness} = $total_population;
  }
  for my $f ( keys %fitness_at ) {
    print "$f $fitness_at{$f}\n";
  }
}

