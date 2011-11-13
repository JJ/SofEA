#!/usr/bin/perl

use strict;
use warnings;

use File::Slurp qw(read_file);

my  @files = @ARGV;

for my $f (@files) {
  my $file_content = read_file($f) || die "Cá pacha!!!! $f $!\n";
  my @sleeps = ($file_content =~ /Sleep/g);
  print scalar(@sleeps), "\n";
}

