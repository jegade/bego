#!env perl

use strict;
use warnings;

use Time::HiRes qw( usleep ualarm gettimeofday tv_interval nanosleep
                      clock_gettime clock_getres clock_nanosleep clock
                                            stat lstat );

use FindBin qw($Bin);
use lib "$Bin/../lib";

use utf8;

use Bego::GPIO;
use Bego::PWM;
use Bego::I2C;



my $direction_pwm1 = Bego::GPIO->init("GPIO2_23",'out');    # P8_29
my $direction_pwm2 = Bego::GPIO->init("GPIO2_24",'out');    # P8_28
my $direction_pwm3 = Bego::GPIO->init("GPIO2_25",'out');    # P8_30
my $direction_pwm4 = Bego::GPIO->init("GPIO0_10",'out');    # P8_31
my $direction_pwm5 = Bego::GPIO->init("GPIO0_11",'out');    # P8_32
my $direction_pwm6 = Bego::GPIO->init("GPIO0_9",'out');    # P8_33

my $pwm1 = Bego::PWM->init("P9_31");   # ehrpwm0a
my $pwm2 = Bego::PWM->init("P9_29");   # ehrpwm0b
my $pwm3 = Bego::PWM->init("P9_14");   # ehrpwm1a
my $pwm4 = Bego::PWM->init("P9_16");   # ehrpwm1b
my $pwm5 = Bego::PWM->init("P8_45");   # ehrpwm2a
my $pwm6 = Bego::PWM->init("P8_46");   # ehrpwm2b


print STDERR "Initalized, ready \n";

$pwm1->set_periode(500000);
$pwm2->set_periode(500000);
$pwm3->set_periode(500000);
$pwm4->set_periode(500000);
$pwm5->set_periode(500000);
$pwm6->set_periode(500000);

$pwm1->start(0,500000,1);
$pwm2->start(0,500000,1);
$pwm3->start(0,500000,1);
$pwm4->start(0,500000,1);
$pwm5->start(0,500000,1);
$pwm6->start(0,500000,1);



foreach my $x ( 1 .. 10 ) {

    $x *= 49999;

    $pwm1->set_duty($x);
    $pwm2->set_duty($x);
    $pwm3->set_duty($x);
    $pwm4->set_duty($x);
    $pwm5->set_duty($x);
    $pwm6->set_duty($x);

    print "Set $x\n";

    usleep(2_000_000);

}






