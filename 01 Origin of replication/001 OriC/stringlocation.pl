use v5.10.0;
use strict;
use warnings;

my $count = 0;
my $string;
my $genome;

open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	$count++;
	if ($count == 1) {
		$string = $line;
	} elsif ($count == 2) {
		$genome = $line;
	}
}
close FILE;

my $len = length($string);
my $genomelen = length($genome);

my $finish = $genomelen - $len;

my %subfreq;

foreach my $i (0 .. $finish) {
	my $sub = substr($genome, $i, $len);
	
	if ($sub eq $string) {
		print "$i ";
	}
}
print "\n";