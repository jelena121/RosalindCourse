use v5.10.0;
use strict;
use warnings;

#scan a sequence for a number of kmers occurring in a particular fixed interval
sub scanwindow {
	my ($seq, $kmer, $clumpnumber) = @_;
	my $len = length($seq);
	my $finish = $len - $kmer;

	my %subfreq;

	foreach my $i (0 .. $finish) {
		my $sub = substr($seq, $i, $kmer);
		$subfreq{$sub}{$i}++;
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
# my @candidates = &scanwindow($genome, $kmerlength, $minclump);
# foreach (@candidates) {
# 	say "$_";
# 	$kmers{$_}++;
# }
# my $number = $#candidates+1;
# print "$number\n";
# 
# my $unique = scalar keys %kmers;


foreach my $i (0 .. $finish) {
	my $windowseq = substr($genome, $i, $window);
	my @results = &scanwindow($windowseq, $kmerlength, $minclump);
	foreach(@results) {
		$kmers{$_}++;	
	}
}

foreach (keys %kmers) {
	print "$_ ";
}
print "\n";
