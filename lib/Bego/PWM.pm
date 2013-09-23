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

    my ($self) = @_;

}

=head2 start

    Start a pwm

=cut

sub init {

    my ( $package, $pin, $duty, $periode, $polarity ) = @_;

    my $options = { pin => $pin };
    my $self = bless $options;

    # Load overlay for ic2
    Bego::DeviceTreeOverlay->load_overlay('am33xx_pwm');

    # Set defaults
    $duty     ||= 0;
    $periode  ||= 2000;
    $polarity ||= 0;

    # Check if
    $self->_check_pin;

    # Load overlay
    $self->load_pin_overlay;

    $self->set_periode($periode);
    $self->set_duty($duty);
    $self->set_polarity($polarity);

    return $self;

}

=hea2 start 

=cut

sub start {

    my ( $self ) = @_;

    my $path = $self->path_for('run');

    open my $d, ">", $path or die $!;
    print $d 1;
    close $d;

    return $self;

}

sub stop {
    
    my ( $self ) = @_;
    
    my $path = $self->path_for('run');

    open my $d, ">", $path or die $!;
    print $d 0;
    close $d;

    return $self;
}


=head2 set_duty

=cut

sub set_duty {

    my ( $self, $duty ) = @_;

    my $path = $self->path_for('duty');

    open my $d, ">", $path or die $!;
    print $d $duty;
    close $d;

    return $self;
}

=head2 set_periode

=cut

sub set_periode {

    my ( $self, $periode ) = @_;


    my $path = $self->path_for('period');

    open my $d, ">", $path or die $!;
    print $d $periode;
    close $d;

    return $self;

}

=head2 set_polarity

=cut

sub set_polarity {

    my ( $self, $polarity ) = @_;

    my $path = $self->path_for('polarity');

    open my $d, ">", $path or die $!;
    print $d $polarity;
    close $d;

    return $self;

}

sub path_for {

    my ( $self, $target ) = @_;

    my $pin = $self->{pin};

    my $base = $self->{base};

    if ( defined $base && -e $base ) { 

    } else { 

        foreach my $c ( 0..100) {

            my $check = sprintf("/sys/devices/ocp.2/pwm_test_%s.%i", $pin, $c);

            if ( -e $check ) {

                $self->{base} = $check;
                $base = $check;
                last;
            }
        }
    }
    
    if ( !defined $base ) {

        warn "Could not start $pin\n";
    }

    if ( defined $target ) { 

        return sprintf("%s/%s", $base, $target);

    } else {

        return $base;
    }

}

sub _check_pin {

    my ($self) = @_;

    my $pin = $self->{pin};

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

        return 1;

    } else {

        die "Unknown pin $pin";
    }

}

sub cleanup {

    my ($self) = @_;

    if ( $self->path_for && -e $self->path_for ) {

        $self->set_duty(0);
        $self->set_periode(2000);
        $self->set_polarity(0);

        $self->unload_pin_overlay;

        return 1;

    } else {

        return;
    }
}

=head2 load_pin_overlay
    
    
=cut

sub load_pin_overlay {

    my ($self) = @_;
    my $pin = $self->{pin};
    return Bego::DeviceTreeOverlay->load_overlay( 'bone_pwm_' . $pin );

}

=head2 unload_pin_overlay

=cut

sub unload_pin_overlay {

    my ($self) = @_;
    my $pin = $self->{pin};
    return Bego::DeviceTreeOverlay->remove_overlay( 'bone_pwm_' . $pin );
}

=head2 DESTROY

    Stop and remove Overlay

=cut

sub DESTROY {

    my $self = shift;
    $self->cleanup;
    print STDERR "- Unloading ".$self->{pin}."\n";
}

1;
