#!/usr/bin/perl

use strict;
use warnings;
my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);
use YAML qw(Load Dump );

for my $f ( @files_to_process ) {
  my $text = read_file( $f ) || die "Can't read $f: $!\n";
  my $total_evals = ($text =~ /initial_population: (\d+)/);
  my @evals = ($text =~ /population: (\d+)/gs);
  map(  $total_evals += $_, @evals);
  print   "$total_evals\n";
}

