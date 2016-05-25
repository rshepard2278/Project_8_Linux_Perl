## Assignment: Week Thirteen
## Version: 03.11.2013.01
## Author: Howard Bates (hbates@northmen.org)
## Purpose: To demonstrate File I/O, split, join, push, pop, shift, unshift, command-line arguments, die, file test

use 5.14.2;
use warnings;

my (@data, @playArray);
my ($DATAFILEIN, $DATAFILEOUT);
use constant COLUMNS => 6;

sub main {
	verifyArguments();
	#setDataFileIn();
	#setDataFileOut();
	#readData();
	#modifyData();
	#printData();
	#writeData();
	#demonstratePlayArray();
}

main();

sub verifyArguments {
	if (!(@ARGV) || !(-e $ARGV[0])) {
		die "\n\nYou must specify correct file name upon command invocation.\n\n";
	}
}

sub setDataFileIn {
	$DATAFILEIN = $ARGV[0];
}

sub setDataFileOut {
	if (!($ARGV[1])) {
		$DATAFILEOUT = "./DATAX.CSV";
	} else {
		$DATAFILEOUT = $ARGV[1];
	}
}

sub readData {
	my $IN;
	my $counter = 0;
	my @tempData = ();
	@data = ();
	open ($IN, '<', $DATAFILEIN);
	while (<$IN>) {
		@tempData = split(/,/);
		for (my $i = 0; $i < COLUMNS; $i++) {
			chomp ($data[$counter][$i] = $tempData[$i]);
		}
		$counter++;
	}
	close $IN;
}

sub modifyData {
	my $size = @data;
	for (my $i = 0; $i < $size; $i++) {
		for (my $j = 0; $j < COLUMNS; $j++) {
			if ($data[$i][$j] =~ s/123 Kitty Street/3901 Brubaker Road/i) {
				print "Change made!\n";
			}
		}
		print "\n";
	}
}

sub printData {
	my $size = @data;
	for (my $i = 0; $i < $size; $i++) {
		for (my $j = 0; $j < COLUMNS; $j++) {
			print "$data[$i][$j] ";
		}
		print "\n";
	}
}

sub writeData {
	my $OUT;
	my $size = @data;
	open ($OUT, '>', $DATAFILEOUT);
	for (my $i = 0; $i < $size; $i++) {
		for (my $j = 0; $j < COLUMNS; $j++) {
			if ($j == COLUMNS - 1) {
				print ($OUT "$data[$i][$j]");
			} else {
				print ($OUT "$data[$i][$j],");
			}
		}
		print ($OUT "\n");
	}
	close $OUT;
}

sub demonstratePlayArray {
	@playArray = ();
	push (@playArray, 3);     # Add to back
	push (@playArray, 4);
	unshift (@playArray, 7);  # Add to front
	unshift (@playArray, 9);
	foreach my $item (@playArray) {
		say "$item";
	}
	pop @playArray;     # Remove from back
	shift @playArray;   # Remove from front
	foreach my $item (@playArray) {
		say "$item";
	}
}