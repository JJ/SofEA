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
  print  $data[@data-1]->[1]->{'Finished'}, "\n";
}
  


