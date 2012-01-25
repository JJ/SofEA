#!/usr/bin/perl

use strict;
use warnings;
my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use DateTime;
use IO::YAML;
use YAML qw(Load);

for my $f ( @files_to_process ) {
  my @data;
  eval {
    my $io = IO::YAML->new($f, "<");
    @data = <$io> ;
  };
  if ( @data ) {
    my $start_time = $data[0]->[0];
    my $end_time = $data[@data-1]->[0];
    my $diff = $end_time - $start_time;
    print $diff->minutes*60+$diff->seconds, "\n";
  }
}
  


