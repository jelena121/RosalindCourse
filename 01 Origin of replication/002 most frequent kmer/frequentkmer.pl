use v5.10.0;
use strict;
use warnings;

sub hashmax {
	my %hash = @_;
	my $max = 0;
	foreach my $number (keys %hash) {
		if ($number > $max) {
			$max = $number
		}
	}
	return $max;
}

my $count = 0;
my $string;
my $number;

open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	$count++;
	if ($count == 1) {
		$string = $line;
	} elsif ($count == 2) {
		$number = $line;
	}
}
close FILE;

my $len = length($string);
my $finish = $len - $number;

my %subfreq;

foreach my $i (0 .. $finish) {
	my $sub = substr($string, $i, $number);
	$subfreq{$sub}++;
}

my %max;

foreach my $kmer (keys %subfreq) {
	my $freq = $subfreq{$kmer};
	$max{$freq}{$kmer}++;	
}

my $maxnumber = &hashmax(%max);
foreach my $winningkmer (keys %{$max{$maxnumber}}) {
	print "$winningkmer ";

}
print "\n";
