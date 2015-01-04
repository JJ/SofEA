#!/usr/bin/perl

use strict;
use warnings;

my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);

for my $f ( @files_to_process ) {
  my $text= read_file($f);
  my @conflicts_evaluated = ( $text =~ /Conflicts: (\d+)\s+Evaluated: (\d+)/gs) ;
  my @conflict_rate;
  my $sum_conflicts;
  my $total_lines = @conflicts_evaluated/2;
  while ( @conflicts_evaluated ) {
    my $conflicts = shift @conflicts_evaluated;
    my $evaluated = shift @conflicts_evaluated;
    $sum_conflicts += $conflicts/$evaluated;
  }
  print scalar $sum_conflicts/$total_lines, "\n";
}
