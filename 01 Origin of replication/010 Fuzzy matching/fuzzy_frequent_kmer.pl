use v5.10.0;
use strict;
use warnings;

my $seq;
my $kmerlength; 
my $mismatch;

open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	($seq, $kmerlength, $mismatch) = split(/ /, $line);
}
close FILE;

say $seq;