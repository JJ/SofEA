#!/usr/bin/perl

use strict;
use warnings;

my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use File::Slurp qw(read_file);

for my $f ( @files_to_process ) {
  my $text= read_file($f);
  my @sleeps = ( $text =~ /Sleep/g) ;
  print scalar @sleeps, "\n";
}

