#!/usr/bin/perl

use strict;
use warnings;

use File::Slurp qw(read_file);

my  @files = @ARGV;

for my $f (@files) {
  my $file_content = read_file($f) || die "Cá pacha!!!! $f $!\n";
  my @best = ($file_content =~ /=> (\d+)/g);
  if  ( $best[$#best] >=  $best[$#best-1] ) {
    print $best[$#best], "\n";
  } else {
    print $best[$#best-1], "\n";
  }
}

