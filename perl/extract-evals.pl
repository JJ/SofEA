#!/usr/bin/perl

use strict;
use warnings;
print "Evaluations, conflicts";
while(<>) {
  if ( /Evaluations/ ) {
    my ( $number_of, $conflicts )  = /(\d+)/g;
    print "$number_of, $conflicts\n";
  }
}

