package Game::Particle;
use strict;
use warnings FATAL => 'all';
use Moo;

use constant {
    R => 1,
    B => 2, 
    G => 3,
    Y => 4,
};
has x => ( is => 'rw', required => 1 );
has y => ( is => 'rw', required => 1 );
has type => ( is => 'ro', required => 1 );

has xdir => ( is => 'lazy' );
has ydir => ( is => 'lazy' );
has char => ( is => 'lazy' );

has rows => ( is => 'ro', required => 1);
has cols => ( is => 'ro', required => 1);

sub _build_xdir {
    my $self = shift;
    for( $self->type ) {
    return -1 if $_ eq R;
    return 1 if $_ eq B;
    }
}

sub _build_ydir {
    my $self = shift;
    return 0;
}

sub _build_char {
    my $self = shift;
    return 'o' if $self->type eq R;
    return 'x' if $self->type eq B;
}
sub xpos {
    my( $self, $xx ) = @_;
    if( $xx >= $self->cols ) {
        $xx -= $self->cols;
    } elsif ( $xx < 0 ) {
        $xx += $self->cols;
    }
    return $xx;
}

sub ypos {
    my( $self, $yy ) = @_;
    if( $yy >= $self->rows ) {
        $yy -= $self->rows;
    } elsif ( $yy < 0 ) {
        $yy += $self->rows;
    }
    return $yy;
}
sub move {
    my $self = shift;
    my $wantx = $self->xpos( $self->x + $self->xdir );
    my $wanty = $self->ypos( $self->y + $self->ydir );
    $self->x( $wantx );
    $self->y( $wanty );
}

1;
