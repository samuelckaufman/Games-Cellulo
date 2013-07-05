package Game;
use strict;
use warnings FATAL => 'all';
use Game::Screen;
use Time::HiRes;
use Game::Particle;
use Data::Dumper::Concise;
use Try::Tiny;


use Moo;
has screen => ( is => 'lazy', handles => [qw/ grid /] );

has num_particles => (
    is => 'ro',
    required => 1,
    default => sub { 200 },
);

has screen_args => ( 
    is => 'ro',
    default => sub { +{} },
);

has particles => ( 
    is => 'rw',
);
sub _rand_dir {
    int( rand(3) ) - 1;
}
sub _build_screen {
    Game::Screen->new( shift->screen_args )
}

sub randx {
    my $self = shift;
    my $cols = $self->screen->cols;
    int( rand( $cols )  );
}

sub randy {
    my $self = shift;
    my $rows = $self->screen->rows;
    int( rand( $rows )  );

}

sub init {
    my $self = shift;
    my $rows = $self->screen->rows;
    my $cols = $self->screen->cols;
    $self->screen->clrscr;
    my $grid = $self->screen->grid;
    my $particles = [
        map {
            my $randy = $self->randy;
            my $randx = $self->randx;
            $grid->[ $randy ][ $randx ] = 
            Game::Particle->new(
                rows => $rows,
                cols => $cols,
                x    => $randx,
                y    => $randy,
                type => int( rand(2) + 1 ),
              )
        } ( 1 .. $self->num_particles ) ];
    
    $self->particles( $particles );
}

sub play {
    my $self = shift;
    $self->draw while ( !$self->screen->key_pressed );
}

sub draw_grid {
    my $self   = shift;
    my $screen = $self->screen;
    my $grid   = $self->screen->grid;
    $screen->at( 0, 0 );
    for ( 0 .. $screen->rows - 1 ) {
        $screen->at( $_, 0 );
        print join "" => map { $_ ? $_->char : "-" } @{ $grid->[$_] };
    }
}
sub move_particles {
    my $self = shift;
    my $grid = $self->screen->grid;
    for ( @{ $self->particles } ) {
        my $wantx = $_->xpos( $_->x + $_->xdir );
        my $wanty = $_->ypos( $_->y + $_->ydir );
        unless ( $grid->[$wanty][$wantx] ) {
            $grid->[$wanty][$wantx] =  $_;
            $grid->[ $_->y ][ $_->x ] = undef;
            $_->x($wantx);
            $_->y($wanty);
        }
    }
}
sub draw {
    my $self = shift;
   $self->screen->at(0,0);
    my $grid = $self->screen->grid;
    $self->move_particles;
#    $self->screen->reset_grid;
    $self->draw_grid;
    Time::HiRes::sleep .05;
}
1;
