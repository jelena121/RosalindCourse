use strict;
use warnings;
#use Bio::Perl;

open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	$line = uc $line;
	my $rev = $line;
	$rev =~ tr/CGTA/GCAT/;
	$rev = reverse $rev;
	print "$rev\n";	
}
close FILE;

