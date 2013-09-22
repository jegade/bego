#!env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/lib";

use utf8;

use Bego::GPIO;


my $pin = Bego::GPIO->init("GPIO2_23",'out');

while (1 ) {

    $pin->write(1);

    sleep 1;

    $pin->write(0);

    sleep 1;



}
