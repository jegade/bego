#use strict;
use warnings;

use Test::More tests => 3;                      # last test to print

BEGIN { use_ok( "Bego::DeviceTreeOverlay" ) };


ok(Bego::DeviceTreeOverlay->load_overlay('am33xx_pwm'));


ok(Bego::DeviceTreeOverlay->overlay_list());
