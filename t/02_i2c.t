#use strict;
use warnings;

use Test::More tests => 2;                      # last test to print

BEGIN { use_ok( 'Bego::I2C' ); }

my $i2c = Bego::I2C->new;

my $dev = $i2c->dev;

isa_ok($dev,'Device::SMBus');

