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
  my $total_conflicts;
  my (@population) = ( $text =~ /total_population: (\d+)/gs) ;
  for (my $i = 0; $i <= $#population; $i ++ ) {
    push(@{$population_sizes_at_step[$i]}, $population[$i]); 
  }

}
 for (my $i = 0; $i <= $#population_sizes_at_step; $i ++ ) {
   my $total ;
   map( $total += $_, @{$population_sizes_at_step[$i]});
   print $total/@{$population_sizes_at_step[$i]}, "\n";
 }
