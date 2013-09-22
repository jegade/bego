#!/usr/bin/perl 
#===============================================================================
#
#         FILE: parse_pinmux.pl
#
#        USAGE: ./parse_pinmux.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 23.09.2013 00:02:51
#     REVISION: ---
#===============================================================================

use strict;
use warnings;


my $p8 = "../extra/pinmux/beaglebone_pins_p8";
my $p9 = "../extra/pinmux/beaglebone_pins_p9";

use Data::Printer;
use Data::Dumper::Names;


open my $p8_fh,"<", $p8 or die "Could not open $p8";
my @lines = map { "p8".$_ } <$p8_fh>;
chomp @lines;
close $p8_fh;

open my $p9_fh,"<", $p9 or die "Could not open $p9";
my @p9_lines = map  { "p9" . $_ } <$p9_fh>;
chomp @p9_lines;
close $p9_fh;


#print Dumper @lines;

my $pins = {};
my $gpio = {};

foreach  ( @lines,@p9_lines ) {

    my ($o,$x, $pin, $proc, $addr, $name, $mode0, $mode1, $mode2,$mode3, $mode4,$mode5, $mode6, $mode7 ) = map { $_ =~ s/\s+//g; $_ } unpack "A2A4A8A11A13A16A17A23A13A20A22A22A20A20";

    if ( $pin =~ /\d/ ) { 

        $pins->{$o}{$pin} = {

            proc => $proc,
            addr => $addr,
            name => $name,
            mode0 => $mode0,
            mode1 => $mode1,
            mode2 => $mode2,
            mode3 => $mode3,
            mode4 => $mode4,
            mode5 => $mode5,
            mode6 => $mode6,
            mode7 => $mode7,
        };

        if ( $mode7 =~ /gpio/ ) { 

            $gpio->{$mode7} = {

                header => $o,
                pin    => $pin
            };

        }
     }

}


print "package Bego::PinMuxHelper;";
print Dumper $pins;
print Dumper $gpio;


