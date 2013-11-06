use v5.10.0;
use strict;
use warnings;

my %skewdata;
my %all;

my $min = 10000;

open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	my @char = split(//, $line);
	
	foreach my $i (0 .. $#char) {
		$all{$char[$i]}++;
		my $g;
		my $c;
		if (exists($all{"G"})) {
			$g = $all{"G"};
		} else {
			$g = 0;
		}
		if (exists($all{"C"})) {
			$c = $all{"C"};
		} else {
			$c = 0;
		}
		
		my $result = $g - $c;
		
		$skewdata{$i} = $result;
		
		if ($result < $min) {
			$min = $result;
		}
	}
}
close FILE;

foreach my $pos (sort {$a <=> $b} keys %skewdata) {
	if ($skewdata{$pos} == $min) {
		my $coord = $pos + 1;
		print "$coord ";
	}
}
print "\n";


