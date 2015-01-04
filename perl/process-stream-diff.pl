#!/usr/bin/perl 

use strict;
use warnings;

use IO::YAML;
use YAML qw(Dump Load);
use File::Slurp qw(write_file);

my $file_name = shift || die "No file\n";
my $io = IO::YAML->new($file_name, "<");

my @chromosomes;
while ( my $d = <$io> ) {
  my $c = Load($d);
  next if (ref $c) !~ /HASH/;
  if ( $c->{'id'} !~ /^_/ 
       && $c->{'changes'}->[0]->{'rev'} =~ /^[12]/ 
       && !$c->{'deleted'} ) {
    push @chromosomes, $c->{'changes'}->[0]->{'rev'};
  }
}

my @total_rev1 = ('total');
my $total_rev1 = 0;
while ( @chromosomes ) {
  my @slice = splice(@chromosomes, 0, 100);
   my %rev = ( '1' => 0,
	       '2' => 0 );
  for my $s ( @slice ) {
    my ($rev) = ( $s =~ /^(\d)-/);
    $rev{"$rev"}++;
  }
  $total_rev1 += $rev{'1'}-$rev{'2'};
  push @total_rev1 , $total_rev1; 
}

my ( $out_file_name   ) = ( $file_name =~ /(.+)\.yaml/);
write_file($out_file_name."-rev.csv", join("\n", @total_rev1));
