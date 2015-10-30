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
        if ($_[1]) {
            $time->set_time_zone($_[1]);
        } else {
            $time->set_time_zone("Europe/Amsterdam");
        }
        print $time->strftime("%Y-%m-%dT%H:%M:%S %Z")."\n";
    } else {
        print str2time($arg) * 1000;
        print "\n";
    }
}

if ( $#ARGV  > -1 ) {
    ts($ARGV[0], $ARGV[1]);
} else {
    while(<STDIN>) {
        ts($_);
    }
}
