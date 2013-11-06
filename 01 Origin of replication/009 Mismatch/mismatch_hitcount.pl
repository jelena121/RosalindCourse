use v5.10.0;
use strict;
use warnings;

sub scanwindow {
	my ($motif, $seq, $mismatch) = @_;
	
	my @motifchar = split(//, $motif);
	my @results;
	
	my $len = length($seq);
	my $kmer = length($motif);
	my $finish = $len - $kmer;
	my $CUTOFF = $kmer - $mismatch;

		
	foreach my $i (0 .. $finish) {
		my $sub = substr($seq, $i, $kmer);
		my @subchar = split(//, $sub);
		
		my $score = 0;
		foreach my $subi (0 .. $#subchar) {
			if ($subchar[$subi] eq $motifchar[$subi]) {
				$score++;
			}
		}
		
		if ($score >= $CUTOFF) {
			push(@results, $i);
		}

	}

	return @results;
}



my $count = 0;
my $motif;
my $sequence;
my $mismatches;


open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	$count++;
	if ($count == 1) {
		$motif = $line;
	}
	if ($count == 2) {
		$sequence = $line;
	}
	if ($count == 3) {
		$mismatches = $line;
	}
}
close FILE;

my @pos = &scanwindow($motif, $sequence, $mismatches);

foreach (@pos) {
	print "$_ ";
}
print "\n";
