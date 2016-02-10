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
# This is laid out to better understand the differences between the letter lists. This first
# one is for all letters, A-Z.
my $letters = [ qw( a b c d e f g h i j k l m n o p q r s t u v w x y z ) ];
# This pinyin list is the favored letters for Chinese domain investors.
my $pinyin  = [ qw(   b c d   f g h   j k l m n   p q r s t     w x y z ) ];
# These are the most desired two-letter Pinyin prefixes.
my $prefix  = [ qw( cn bj sh gd ) ];
# These are the most desired two-letter Pinyin suffixes.
my $suffix  = [ qw( cn lc zx kj sj ) ];
# Numbers.
my $number1 = [ ( 0 .. 9 ) ];
# Numbers spelled out.
my $number2 = [ qw( zero one two three four five six seven eight nine ) ];
# Single word number words.
my $number3 = [ qw( eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen ) ];
# Single word number words, product of ten.
my $number4 = [ qw( ten twenty thirty fourty fifty sixty seventy eighty ninety hundred ) ];

if ( !$ARGV[0] ) {
	print "What pattern would you like to search? ";
	chomp($reply=<STDIN>);
	if ( $reply =~ m/^[a-z,0-9,-]{1,10}$/i ) {
		print "Pattern is okay.\n" if $debug > 0;
		print "Okay, searching for $reply.\n";
	}
	else {
		print "Bad pattern. Expected A-Z, 0-9, -, length from 1 to 10 characters. Please try again.\n";
		exit ();
	};
}

my ( @ctype, @carray );
my @chars = split //, $reply;
my $ccount = scalar @chars;
print "There are $ccount characters. Loading data...\n" if $debug > 0;
for my $c ( 0 .. $#chars ) {
	if ( $chars[$c] =~ m/N/ )    { $carray[$c]    = $number1;   }
	elsif ( $chars[$c] =~ m/L/ ) { $carray[$c]    = $letters;   }
	elsif ( $chars[$c] =~ m/P/ ) { $carray[$c]    = $pinyin;    }
	elsif ( $chars[$c] =~ m/E/ ) { $carray[$c]    = $prefix;    }
	elsif ( $chars[$c] =~ m/U/ ) { $carray[$c]    = $suffix;    }
	elsif ( $chars[$c] =~ m/Z/ ) { $carray[$c]    = $number2;   }
	elsif ( $chars[$c] =~ m/V/ ) { $carray[$c]    = $number3;   }
	elsif ( $chars[$c] =~ m/T/ ) { $carray[$c]    = $number4;   }
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

