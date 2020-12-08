#!/usr/bin/env perl

# perl $0 StructureResultsWithSampleName SampleList

use strict;
use warnings;

my $fStru = $ARGV[0];
my $fSort = $ARGV[1];

my %hSort=();
my $i=0;

open (Sort,${fSort});
while (<Sort>){
	$i++;
	chomp;
	$_=~s/^\s+|\s+$//g;
	$hSort{$_}=$i;
}
close (Sort);

open (SRT, ${fStru});
while (<SRT>) {
    #P401AD4	  1:   0.2016  0.7984  1
    #B40AD4-16	  2:   0.2012  0.7988  1
    chomp;
    $_=~s/^\s+|\s+$//g;
    my ($ID,@vals) = split (/\t| /, $_);
    if ( exists $hSort{$ID} ){
	print $hSort{$ID}."\t".$_."\n";
    }
}

close (SRT);
