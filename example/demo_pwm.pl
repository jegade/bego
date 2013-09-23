#!env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use utf8;

use Bego::GPIO;
use Bego::PWM;
use Bego::I2C;

my $direction_pwm1 = Bego::GPIO->init("GPIO2_23",'out');
my $direction_pwm2 = Bego::GPIO->init("GPIO2_24",'out');
my $direction_pwm3 = Bego::GPIO->init("GPIO2_25",'out');
my $direction_pwm4 = Bego::GPIO->init("GPIO2_26",'out');
my $direction_pwm5 = Bego::GPIO->init("GPIO2_27",'out');
my $direction_pwm6 = Bego::GPIO->init("GPIO2_28",'out');

my $pwm1 = Bego::PWM->init("P8_13",0,2000,0);
my $pwm2 = Bego::PWM->init("P8_34",0,2000,0);
my $pwm3 = Bego::PWM->init("P8_45",0,2000,0);
my $pwm4 = Bego::PWM->init("P9_14",0,2000,0);
my $pwm5 = Bego::PWM->init("P9_31",0,2000,0);
my $pwm6 = Bego::PWM->init("P9_21",0,2000,0);

print STDERR "Initalized, ready \n";





