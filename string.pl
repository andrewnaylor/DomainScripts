#!/usr/bin/perl
#
# This script is for generating lists of strings that can be used to register domain names.
#
use strict;
use warnings;
use Set::CrossProduct;

my $debug = 0;
my $reply="";
if ( $ARGV[0] ) { $reply = $ARGV[0]; }

# This is laid out to better understand the differences between the letter lists.

# All letters, a-z.
my $letters = [ qw( a b c d e f g h i j k l m n o p q r s t u v w x y z ) ];

# This pinyin list is the favored letters for Chinese domain investors.
my $pinyin  = [ qw(   b c d   f g h   j k l m n   p q r s t     w x y z ) ];

# Letters and numbers
my $letnum  = [ qw( a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9 ) ];

# These are the most desired two-letter Pinyin prefixes.
my $prefix  = [ qw( cn bj sh gd ) ];

# These are the most desired two-letter Pinyin suffixes.
my $suffix  = [ qw( cn lc zx kj sj ) ];

# Numbers.
my $numberN = [ ( 0 .. 9 ) ];

# Numbers spelled out, except zero (for spelling out number combinations like twentyone
my $numberY = [ qw( one two three four five six seven eight nine ) ];

# Numbers spelled out.
my $numberZ = [ qw( zero one two three four five six seven eight nine ten ) ];

# Single word number words.
my $numberV = [ qw( eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen ) ];

# Single word number words, product of ten.
my $numberT = [ qw( twenty thirty fourty fifty sixty seventy eighty ninety ) ];

if ( !$ARGV[0] ) {
	print "To generate a list of strings, enter a pattern using the following letters:

	L - letters [a-z]
	N - numbers [0-9]
	C - letters and numbers [a-z, 0-9]
	P - pinyin [a-z without a, e, i, o, u, v]
	E - pinyin prefixes [cn, bj, sh, gd]
	U - pinyin suffixes [cn, lc, zx, kj, sj]
	Y - numbers spelled out from 1 - 9   [one, two, three...]
	Z - numbers spelled out from 0 - 9   [zero, one, two...]
	V - numbers spelled out from 11 - 19 [eleven, twelve, thirteen...]
	T - numbers spelled out mulitples of ten [twenty, thirty, fourty...]
	- - dash
	. - dot
	[lowercase letters] - it lists the literal letters nnn = \"nnn\", .com = \".com\"

Examples:

	NN: 		A list of all two letter strings
	xyzN.net: 	A list of .NETs starting with \"xyz\" ending in [0-9]
	Z.com, V.com, T.com, TY.com:
			A list of .COMs from zero - ninetyninetynine

Turning off interactive mode

	To turn off interactive mode, run this command with a pattern on the command line:
	./string.pl NN.org
	./string.pl LLLL

What pattern would you like to search? ";
	chomp($reply=<STDIN>);
	if ( $reply =~ m/^[a-z,0-9,-,.]{2,10}$/i ) {
		print "Pattern is okay.\n" if $debug > 0;
		print "Okay, searching for $reply.\n";
	}
	else {
		print "Bad pattern. Expected A-Z, a-z, 0-9, -, ., length from 2 to 10 characters. Please try again.\n";
		exit ();
	};
}

my ( @ctype, @carray );
my @chars = split //, $reply;
my $ccount = scalar @chars;
print "There are $ccount patterns to search. Loading data...\n" if $debug > 0;
for my $c ( 0 .. $#chars ) {
	if ( $chars[$c] =~ m/N/ )    { $carray[$c]    = $numberN;   }
	elsif ( $chars[$c] =~ m/L/ ) { $carray[$c]    = $letters;   }
	elsif ( $chars[$c] =~ m/C/ ) { $carray[$c]    = $letnum;    }
	elsif ( $chars[$c] =~ m/P/ ) { $carray[$c]    = $pinyin;    }
	elsif ( $chars[$c] =~ m/E/ ) { $carray[$c]    = $prefix;    }
	elsif ( $chars[$c] =~ m/U/ ) { $carray[$c]    = $suffix;    }
	elsif ( $chars[$c] =~ m/Y/ ) { $carray[$c]    = $numberY;   }
	elsif ( $chars[$c] =~ m/Z/ ) { $carray[$c]    = $numberZ;   }
	elsif ( $chars[$c] =~ m/V/ ) { $carray[$c]    = $numberV;   }
	elsif ( $chars[$c] =~ m/T/ ) { $carray[$c]    = $numberT;   }
	else                         { $carray[$c][0] = $chars[$c]; };
	print "$c - $chars[$c]\n" if $debug > 1;
}

my $count = 0;
my $cross_product = Set::CrossProduct->new( [ @carray ] );
my @combinations  = $cross_product->combinations;
foreach my $item ( @combinations ) {
	my $line = "@$item\n";
	$line =~ s/\ //g;
	print $line;
	#print "@$item\n";
	$count++;
	if ( $count % 500 == 0 ) { print "\n"; };
}

