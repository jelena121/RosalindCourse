use v5.10.0;
use strict;
use warnings;

#scan a sequence for a number of kmers occurring in a particular fixed interval
sub scanwindow {
	my ($seq, $kmer, $clumpnumber) = @_;
	my $len = length($seq);
	my $finish = $len - $kmer;

	my %subfreq;
	my %results;
	
	foreach my $i (0 .. $finish) {
		my $sub = substr($seq, $i, $kmer);
		$subfreq{$sub}{$i}++;
	}

	foreach my $kmer (keys %subfreq) {
		my $freq = scalar keys %{$subfreq{$kmer}};
		if ($freq >= $clumpnumber) {
			foreach my $pos (keys %{$subfreq{$kmer}}) {
				$results{$kmer}{$pos}++;
			}
		}
	}
	return %results;
}

my $count = 0;
my $genome;
my $parameters;
open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	$count++;
	if ($count == 1) {
		$genome = $line;
	} elsif ($count == 2) {
		$parameters = $line;
	}
}
close FILE;

my @par = split(/ /, $parameters);
my $kmerlength = $par[0];
my $window = $par[1];
my $minclump = $par[2];

my $len = length($genome);
my $finish = $len - $window;

my %kmers;

my %candidates = &scanwindow($genome, $kmerlength, $minclump);
foreach my $kmer (%candidates) {
	my @pos;
	foreach my $i (sort {$a <=> $b} keys %{$candidates{$kmer}}) {
		push (@pos, $i);
	}
	my $end = $#pos - $minclump + 1;
	
	foreach my $index (0 .. $end) {
		my $next = $index + $minclump - 1;
		my $dist = $pos[$next] - $pos[$index] + 1 +$kmerlength - 1;
		if ($dist < $window) {
			$kmers{$kmer}++;
		} 
	}
}

foreach (keys %kmers) {
	#say $_;
}

my $number = scalar keys %kmers;
say $number;