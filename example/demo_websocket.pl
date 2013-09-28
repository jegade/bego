#!env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";


use utf8;

use Bego::GPIO;
use Bego::PWM;
use Bego::I2C;
use Mojolicious::Lite;
use Mojo::IOLoop;

my $direction_pwm1 = Bego::GPIO->init( "GPIO2_23", 'out' );    # P8_29
my $direction_pwm2 = Bego::GPIO->init( "GPIO2_24", 'out' );    # P8_28
my $direction_pwm3 = Bego::GPIO->init( "GPIO2_25", 'out' );    # P8_30
my $direction_pwm4 = Bego::GPIO->init( "GPIO0_10", 'out' );    # P8_31
my $direction_pwm5 = Bego::GPIO->init( "GPIO0_11", 'out' );    # P8_32
my $direction_pwm6 = Bego::GPIO->init( "GPIO0_9",  'out' );    # P8_33

my $pwm1 = Bego::PWM->init("P9_31");                           # ehrpwm0a
my $pwm2 = Bego::PWM->init("P9_29");                           # ehrpwm0b
my $pwm3 = Bego::PWM->init("P9_14");                           # ehrpwm1a
my $pwm4 = Bego::PWM->init("P9_16");                           # ehrpwm1b
my $pwm5 = Bego::PWM->init("P8_45");                           # ehrpwm2a
my $pwm6 = Bego::PWM->init("P8_46");                           # ehrpwm2b

print STDERR "Initalized, ready \n";

$pwm1->start( 0, 500000, 1 );
$pwm2->start( 0, 500000, 1 );
$pwm3->start( 0, 500000, 1 );
$pwm4->start( 0, 500000, 1 );
$pwm5->start( 0, 500000, 1 );
$pwm6->start( 0, 500000, 1 );

# Template with browser-side code
get '/' => 'index';

# WebSocket echo service
websocket '/echo' => sub {

    my $self = shift;

    # Opened
    $self->app->log->debug('WebSocket opened.');

    # Increase inactivity timeout for connection a bit
    Mojo::IOLoop->stream( $self->tx->connection )->timeout(300);

    # Incoming message
    $self->on(
        json => sub {
            my ( $self, $msg ) = @_;

            $pwm1->set_duty($msg->{pwm1});
            $pwm2->set_duty($msg->{pwm2});
            $pwm3->set_duty($msg->{pwm3});
            $pwm4->set_duty($msg->{pwm4});
            $pwm5->set_duty($msg->{pwm5});
            $pwm6->set_duty($msg->{pwm6});

            $self->send("ok");
        }
    );

    # Closed
    $self->on(
        finish => sub {
            my ( $self, $code, $reason ) = @_;
            $self->app->log->debug("WebSocket closed with status $code.");
        }
    );
};

app->start;
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
<head><title>Echo</title></head>
<body>
    <script>
    var ws = new WebSocket('<%= url_for('echo')->to_abs %>');

    // Incoming messages
    ws.onmessage = function(event) {
        // document.body.innerHTML += event.data + '<br/>';
    };

    // Outgoing messages
    window.setInterval(function() {
       
        var set = {};   
        set['pwm1'] = document.getElementById('pwm1').value;
        set['pwm2'] = document.getElementById('pwm2').value;
        set['pwm3'] = document.getElementById('pwm3').value;
        set['pwm4'] = document.getElementById('pwm4').value;
        set['pwm5'] = document.getElementById('pwm5').value;
        set['pwm6'] = document.getElementById('pwm6').value;
      
        var pay = JSON.stringify(set);
        ws.send(pay)
        console.dir(set);;
        
    }, 20);
    </script>

    1. <input type="range" value="0" min="0" max="500000" step="500" id="pwm1" />
    2. <input type="range" value="0" min="0" max="500000" step="500" id="pwm2" />
    3. <input type="range" value="0" min="0" max="500000" step="500" id="pwm3" />
    4. <input type="range" value="0" min="0" max="500000" step="500" id="pwm4" />
    5. <input type="range" value="0" min="0" max="500000" step="500" id="pwm5" />
    6. <input type="range" value="0" min="0" max="500000" step="500" id="pwm6" />



</body>
</html>

