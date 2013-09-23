#!env perl

use strict;
use warnings;

package Bego::GPIO;

use AnyEvent;

=head2 new

    Initialize 

=cut

sub new {

    my ( $self, $options ) = @_;

    $options->{pins} = {};

    return bless $options;
}

sub init {

    my ( $self, $name, $direction ) = @_;

   
    my $pin_options = {

        pin => $name,
        direction => $direction,
    };

    my $pin = bless $pin_options;

    $pin->set_direction($direction);
    
    return $pin;
 
}

=head2 set_direction 

=cut

sub set_direction {

    my ( $self, $direction ) = @_;

    my $path_direction = $self->path_for("direction");

    open  my $e, ">", $path_direction;
    print $e $direction;
    close $e;

    return $direction;
}

=head2 write

    Write the value to the pin

=cut

sub write {

    my ( $self,$value ) = @_;

    my $path = $self->path_for( "value");

    open my $e, ">", $path;
    print $e $value;
    close $e;

    return $value;
}

=head2 read

=cut

sub read {

    my ( $self ) = @_;

    my $pin = $self->{pin};

    my $path = $self->path_for("value");

    open my $e, "<", $path;
    my $value = <$e>;
    close $e;

    return $value;

}

=head2 wait_for_change
    
    Interrupt based or 

=cut

sub wait_for_change {

    my ( $self,$cb ) = @_;

    my $path = $self->path_for( "value" );

    my $w;

    open my $fh,"<", $path;

    $w = AnyEvent->io(
        fh   => $path,
        poll => 'r',
        cb   => sub {

            my $value = <$fh>;
            print STDERR $value;
        }
    );

}

=head2 path_for

=cut

sub path_for {

    my ( $self, $type ) = @_;

    my $pin = $self->{pin} or die;

    my $pins = {};

    foreach my $b ( 0 .. 3 ) {

        foreach my $i ( 0 .. 31 ) {

            $pins->{"GPIO".$b."_".$i} = $b * 32 + $i;
        }

    }

    die "Could not found $pin" unless exists $pins->{$pin};

    my $basepath = sprintf("/sys/class/gpio/gpio%i",$pins->{$pin});

    if (! -e $basepath ) { 

        open my $export, ">", "/sys/class/gpio/export";
        print $export $pins->{$pin};
        close $export;
    }

    if ( -e $basepath ) {

        return sprintf("%s/%s", $basepath, $type );

    } else {

        die "Could not open $basepath";

    }
}

=head2 DESTROY

    Remove Overlay

=cut

sub DESTROY {

}

1;
