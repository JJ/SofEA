#!/usr/bin/perl

use strict;
use warnings;

my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);

for my $f ( @files_to_process ) {
  my $text= read_file($f);
  my ($base_population) = ( $text =~ /repro_pop_size: (\d+)/ );
  my @conflicts_and_evaluated = ( $text =~ /conflicts: (\d+)\s+population: (\d+)/gs) ;
  my $total;
  my $size =  @conflicts_and_evaluated /2;
  while( @conflicts_and_evaluated ) {
    my ($conflicts,$evaluated) = splice( @conflicts_and_evaluated,0,2 );
    $total += $evaluated - $conflicts;
  }
  print scalar $total/($size*$base_population), "\n";
}

