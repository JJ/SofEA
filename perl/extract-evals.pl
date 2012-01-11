#!/usr/bin/perl

use strict;
use warnings;
my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use IO::YAML;
use YAML qw(Load);

for my $f ( @files_to_process ) {
  my $io = IO::YAML->new($f, "<");
  my @data = <$io> ;
  my $total_evals = $data[0][1]{'base_population'};
  for my $d (@data[1..$#data]) {
    if ( ref $d ) {
      $total_evals += $d->{'Deleted'};
    }
  }
  print   "$total_evals\n";
}

