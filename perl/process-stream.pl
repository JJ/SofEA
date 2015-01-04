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

my @revs_by_slice = (['rev1','rev2']);
while ( @chromosomes ) {
  my @slice = splice(@chromosomes, 0, 1000);
  my %rev = ( '1' => 0,
	      '2' => 0 );
  for my $s ( @slice ) {
    my ($rev) = ( $s =~ /^(\d)-/);
    $rev{"$rev"}++;
  }
  my  $sum_revs = $rev{'1'}+$rev{'2'};
  push @revs_by_slice , 
    [$rev{'1'}/$sum_revs, $rev{'2'}/$sum_revs];
}

my ( $out_file_name   ) = ( $file_name =~ /(.+)\.yaml/);
write_file("$out_file_name.csv", join("\n", map( join(",",@$_),@revs_by_slice)));
