#!env perl

use warnings;
use strict;

package Bego::DeviceTreeOverlay;

sub _find_slots {

    foreach my $n ( 7, 8, 9 ) {

        my $slots = sprintf( "/sys/devices/bone_capemgr.%i/slots", $n );

        return $slots if -e $slots;

    }

    die "Could not find /sys/devices/bone_capemgr.X/slots";

}

=head2 _exist_overlay

=cut

sub _exist_overlay {

    my $self = shift;
    my $name = shift;

    my $file = sprintf( "/lib/firmware/%s-00A0.dtbo", $name );

    if ( -e $file ) {

        return $file;

    } else {

        die "Could not find overlay $file\n";
    }

}

=head2 parse_slots

=cut

sub parse_slots {

    my $self = shift;

    my $slots = $self->_find_slots;

    open my $slotlist, "<", $slots or die "Could not open $slots: $!";

    my @slots = <$slotlist>;

    close $slotlist;

    my $set = {};

    foreach my $slot (@slots) {

        chomp $slot;

        my ( $nr, $hex, $more ) = split( ":", $slot );

        my $flags = substr $more, 0, 6, "";

        my ( $text, $version, $override, $name ) = split( ",", $more );

        $text = "" unless $text;

        $nr =~ s/\s//g;
        $text =~ s/\s//g;

        $set->{$nr} = {

            hex      => $hex,
            flags    => $flags,
            text     => $text,
            version  => $version,
            override => $override,
            name     => $name,

        };

    }

    return $set;

}

=head2 _is_loaded

=cut

sub _is_loaded {

    my $self = shift;
    my $name = shift;

    my $set = $self->parse_slots;

    foreach my $s ( values %$set ) {
        return $s if defined $s->{name} && $s->{name} eq $name;
    }

    return;
}

=head2 load_overlay

    Load an overlay 

=cut

sub load_overlay {

    my ( $self, $name ) = @_;

    my $set = $self->parse_slots;

    # Check if overlay found
    $self->_exist_overlay($name);

    if ( !$self->_is_loaded($name) ) {

        $self->_write_slots($name);
    }

    return 1;
}

=head2 remove_overlay

=cut

sub remove_overlay {

    my ( $self, $name ) = @_;

    if ( my $slot = $self->_is_loaded($name) ) {

        if ( defined $slot->{nr} ) {

            $self->_write_slots( "-" . $slot->{nr} );
        }
    }
}


sub overlay_list {

    my ( $self ) = @_;

    my $set = $self->parse_slots;

    return map { $_->{name} } grep { defined $_->{name}  } values $set;
}

=head2 _write_slots

=cut

sub _write_slots {

    my ( $self, $content ) = @_;

    my $slots = $self->_find_slots;

    open my $slotlist, ">", $slots or die "Could not open $slots: $!";

    print $slotlist $content;

    close $slotlist;

}

1;
