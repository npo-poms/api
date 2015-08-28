#!/usr/bin/env perl
use strict;
use warnings;

use DateTime;
use Date::Parse;



sub ts {
    my $arg = $_[0];
    if ($arg =~ /^\d+(\.\d+)?$/) {
        if ($arg > 9999999999) {
            $arg /= 1000;

        }
        my $time = DateTime->from_epoch(epoch=>$arg);
        print $time."\n";
    } else {
        print str2time($arg) * 1000;
        print "\n";
    }
}

if ( $#ARGV  > -1 ) {
    ts($ARGV[0]);
} else {
    while(<STDIN>) {
        ts($_);
    }
}
