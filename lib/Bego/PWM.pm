#!env perl

use strict;
use warnings;

package Bego::PWM;

use Bego::DeviceTreeOverlay;
use Bego::GPIO;



=head2 new

    Initialize 

=cut

sub new {

    my ( $self, $options ) = @_;

    # Load overlay for ic2
    Bego::DeviceTreeOverlay->load_overlay('am33xx_pwm');



    return bless $options;
}

=head2 start

    Start a pwm

=cut

sub start {

    my ( $self, $pin, $duty, $freq, $polarity) = @_;

    # Set defaults
    $duty       ||= 0;
    $freq       ||= 2000;
    $polarity   ||= 0;

    # Check if 
    $self->_check_pin( $pin);

    #


}

=head2 set_duty

=cut

sub set_duty {

    my ( $self, $pin ) = @_;


}

=head2 set_frequency

=cut

sub set_frequency {

    my ( $self, $pin, $freq) = @_;




}

=head2 set_direction

=cut

sub set_direction {

    my ( $self, $pin, $direction ) = @_;

}

sub _check_pin {

    my ( $self, $pin ) = @_;

    return 1 if $self->{state}{$pin};

    my $pins = {

        "P8_13" => 1,
        "P8_19" => 1,
        "P8_34" => 1,
        "P8_36" => 1,
        "P8_45" => 1,
        "P8_46" => 1,
        "P9_14" => 1,
        "P9_16" => 1,
        "P9_21" => 1,
        "P9_22" => 1,
        "P9_28" => 1,
        "P9_29" => 1,
        "P9_31" => 1,
        "P9_42" => 1,
    };

    if ( exists $pins->{$pin} ) {

        $self->{state}{$pin} = "running";

        return 1;

    } else {

        die "Unknown pin $pin";
    }


}

sub stop {

    my ( $self, $pin ) = @_;

    if ( exists $self->{state}{$pin} ) {

        $self->set_duty( $pin, 0 );
        $self->set_frequency( 2000);
        $self->set_direction( 0);

        delete $self->{state}{$pin};
        $self->unload_pin_overlay( $pin );

        return 1;

    } else {

        return;
    }
}


=head2 load_pin_overlay
    
    
=cut

sub load_pin_overlay {

    my ( $self, $pin ) = @_;
    return Bego::DeviceTreeOverlay->load_overlay('bone_pwm_'.$pin);

}

=head2 unload_pin_overlay

=cut

sub unload_pin_overlay {

    my ( $self, $pin ) = @_;
    return Bego::DeviceTreeOverlay->remove_overlay('bone_pwm_'.$pin);
}


=head2 DESTROY

    Remove Overlay

=cut

sub DESTROY {

    Bego::DeviceTreeOverlay->remove_overlay('BB-I2C1A1');
    
}

1;
