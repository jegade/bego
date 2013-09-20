#!env perl

use strict;
use warnings;

package Bego::I2C;

use Device::SMBus;
use Bego::DeviceTreeOverlay;

=head2 new

    Initialize 

=cut

sub new {

    my ( $self, $options ) = @_;

    # Load overlay for ic2
    Bego::DeviceTreeOverlay->load_overlay('BB-I2C1A1');

    # Create SMBus
    $options->{dev} = Device::SMBus->new(
        I2CBusDevicePath => '/dev/i2c-1',
        I2CDeviceAddress => 0x20,
    );

    return bless $options;
}

=head2 pinout

    Print the pins 

=cut

sub pinout {

    print "Info I2C\n";
    print "Pins P9 26 sda\n";
    print "Pins P9 24 scl\n";

}

=head2 dev

    Expose Deve
    
=cut

sub dev  {

    my ( $self ) = @_;
    return $self->{dev};

}

=head2 DESTROY

    Remove Overlay

=cut

sub DESTROY {

    Bego::DeviceTreeOverlay->remove_overlay('BB-I2C1A1');
    
}

1;
