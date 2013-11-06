use v5.10.0;
use strict;
use warnings;

sub scanwindow {
	my ($seq, $kmer, $clumpnumber) = @_;
	my $len = length($seq);
	my $finish = $len - $kmer;

	my %subfreq;

	my @results;
	
	foreach my $i (0 .. $finish) {
		my $sub = substr($seq, $i, $kmer);
		$subfreq{$sub}++;
	}

	foreach my $kmer (keys %subfreq) {
		my $freq = $subfreq{$kmer};
		if ($freq >= $clumpnumber) {
			push(@results, $kmer);
		}
	}
	return @results;
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

foreach my $i (0 .. $finish) {
	my $windowseq = substr($genome, $i, $window);
	my @results = &scanwindow($windowseq, $kmerlength, $minclump);
	foreach(@results) {
		$kmers{$_}++;	
	}
}

foreach (keys %kmers) {
	print "$_\n";
}

