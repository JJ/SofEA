#!/usr/bin/perl

use strict;
use warnings;

my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);

my @evaluated_all;
for my $f ( @files_to_process ) {
  my $text= read_file($f);
  my @evaluated = ( $text =~ /Evaluated: (\d+)/g) ;
  my @evaluated_acc = ($evaluated[0]);
  for ( my $i = 1; $i <$#evaluated; $i++ ) {
    $evaluated_acc[$i] = $evaluated[$i]+ $evaluated_acc[$i-1] ;
  }
  for ( my $i = 0; $i <$#evaluated; $i++ ) {
    push( @{$evaluated_all[$i]}, $evaluated_acc[$i]);
  }
}
for my $e ( @evaluated_all ) {
  my $total;
  map( $total += $_ , @$e );
  print $total / @$e, "\n";
}

