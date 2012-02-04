#!/usr/bin/perl

use strict;
use warnings;
my $files = shift || die "No files: usage $0 <files>\n";
my @files_to_process = glob $files;

use IO::YAML;
use YAML qw(Load);

for my $f ( @files_to_process ) {
  my ($output) =  ($f =~ /(.+)\.yaml/);
  open my $ofh, ">", "$output-evals-fitness.csv";
  $ofh->print("Evals;Fitness\n");
  my $io = IO::YAML->new($f, "<");
  while ( my $yaml_data = <$io> ) {
    my $data =Load($yaml_data);
    next if ref $data ne 'HASH';
    $ofh->print($data->{'Evaluations'}. ";". $data->{'Best'}->{'fitness'}. "\n");
  }
  
}

