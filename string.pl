#!/usr/bin/perl
use strict;
use warnings;
use Set::CrossProduct;

my $debug = 0;
my $reply="";
if ( $ARGV[0] ) { $reply = $ARGV[0]; }
my $letters = [ qw( a b c d e f g h i j k l m n o p q r s t u v w x y z ) ];
my $pinyin  = [ qw(   b c d   f g h   j k l m n   p q r s t     w x y z ) ];
my $numbers = [ ( 0 .. 9 ) ];
my @numbers = ( 0 .. 9 );

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
	if ( $chars[$c] =~ m/N/ )    { $carray[$c]    = $numbers;   }
	elsif ( $chars[$c] =~ m/L/ ) { $carray[$c]    = $letters;   }
	elsif ( $chars[$c] =~ m/P/ ) { $carray[$c]    = $pinyin;    }
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

