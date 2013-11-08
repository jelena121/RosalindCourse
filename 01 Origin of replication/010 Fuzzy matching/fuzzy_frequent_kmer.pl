use v5.10.0;
use strict;
use warnings;

#scan a sequence for a number of kmers occurring in a particular fixed interval
sub scanwindow {
	my ($seq, $kmer) = @_;
	my $len = length($seq);
	my $finish = $len - $kmer;

	my %subfreq;
	foreach my $i (0 .. $finish) {
		my $sub = substr($seq, $i, $kmer);
		$subfreq{$sub}++;
	}
	return %subfreq;
}


my $seq;
my $kmerlength; 
my $mismatch;

open FILE, $ARGV[0];
while (my $line = <FILE>) {
	chomp $line;
	($seq, $kmerlength, $mismatch) = split(/ /, $line);
}
close FILE;

my $THRESHOLD = $kmerlength - $mismatch;

my %kmers = &scanwindow ($seq, $kmerlength);

my %results;

#find ones that match
foreach my $kmer (keys %kmers) {
	my @seq1 = split(//, $kmer);
	
	foreach my $kmer2 (keys %kmers) {
			my @seq2 = split(//, $kmer2);
			my $score = 0;
						
			foreach my $i (0 .. $#seq1) {
				if ($seq1[$i] eq $seq2[$i]) {
					$score++;
				} 
			}			
			if ($score >= $THRESHOLD) {
				$results{$kmer}{$kmer2} = $kmers{$kmer2};
			}
	}
}

my %maxkmers;
my $maxscore = 0;

#which are the most frequent
foreach my $root (keys %results) {
	my $score = 0;
	my @seq;
	foreach my $matches (sort keys %{$results{$root}}) {
		$score = $score + $results{$root}{$matches};
		push (@seq, $matches);
		if ($maxscore < $score) {
			$maxscore = $score;
		}	
	}
	my $numberofseq = scalar @seq;
	my $matchkey = $seq[0];
	if ($numberofseq == 1) {
	} else {
		foreach my $i (1 .. $#seq) {
			$matchkey = $matchkey."\t$seq[$i]";
		}
	}
	$maxkmers{$score}{$matchkey}++;
	
}

#say $maxscore;
foreach my $results (keys %{$maxkmers{$maxscore}}) {
	#say $results;
	my @frequentkmers = split(/\t/, $results);
	my %pwm;
	foreach my $freqseq (@frequentkmers) {
		my $score = $kmers{$freqseq};
		#say "\t$freqseq $score";
		my @sequence = split(//, $freqseq);
		foreach my $i (0 .. $#sequence) {	
			if (exists($pwm{$i}{$sequence[$i]})) {
				$pwm{$i}{$sequence[$i]} = $pwm{$i}{$sequence[$i]} + $score;
			}  else {
				$pwm{$i}{$sequence[$i]} = $score;
			}

		}	
	}
	
	my $winnerseq;
	
	foreach my $position (sort {$a <=> $b} keys %pwm) {
		my $max = 0;
		my $maxbase;
		foreach my $base (keys %{$pwm{$position}}) {
			my $basescore = $pwm{$position}{$base};
			#say "$position\n\t$base $basescore";
			if ($basescore > $max) {
				$max = $basescore;
				$maxbase = $base;
			}
		}
		$winnerseq = $winnerseq.$maxbase;
		
	}
	print "$winnerseq ";
}
print "\n";



