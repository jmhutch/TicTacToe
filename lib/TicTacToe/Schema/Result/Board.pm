use strict;
use warnings;

package TicTacToe::Schema::Result::Board;

use base 'TicTacToe::Schema::Result';

our @locations = (qw/tl tc tr ml mc mr bl bc br/);
our @winning_conditions = (
  # horizontal row
  [ qw/tl tc tr/ ],
  [ qw/ml mc mr/ ],
  [ qw/bl bc br/ ],
  # vertical row
  [ qw/tl ml bl/ ],
  [ qw/tc mc bc/ ],
  [ qw/tr mr br/ ],
  # diagonal line
  [ qw/tl mc br/ ],
  [ qw/tr mc bl/ ]
);

__PACKAGE__->load_components('Ordered');
__PACKAGE__->table('board');
__PACKAGE__->add_columns(
  board_id => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  fk_game_id => {
    data_type => 'integer',
    is_foreign_key => 1,
  },
  move => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  ( map { $_ => {
    data_type => 'character',
    is_nullable => 1,
  }} @locations),
  status => {
    date_type => 'enum',
    default_value => 'in_play',
    extra => { list => [qw/in_play draw X_wins O_wins/] },
  });

__PACKAGE__->position_column('move');
__PACKAGE__->grouping_column('fk_game_id');
__PACKAGE__->set_primary_key('board_id');
__PACKAGE__->belongs_to(
  game => '::Game',
  { 'foreign.game_id' => 'self.fk_game_id' });

# On insert we need to see if there is going to be a winner, or a draw
# and update status based on this.

sub insert {
  my ( $self, @args ) = @_;

  # Is the new proposed board we are about to insert resulting in a winner?
  foreach my $who (qw/X O/) {
    foreach my $cond(@winning_conditions) {
      if(
        (($self->${\$cond->[0]}||'') eq $who) and
        (($self->${\$cond->[1]}||'') eq $who) and
        (($self->${\$cond->[2]}||'') eq $who)
      ) {
        $self->status($who.'_wins');
        $self->next::method(@args);
        return $self;
      }
    }
  }

  # If there are no available moves, its a draw
  if(scalar $self->available_moves == 0) {
    $self->status('draw');
  }

  $self->next::method(@args);
  return $self;
}

sub whos_turn {
  my $self = shift;
  $self->move % 2 ? 'X' : 'O';
}

sub available_moves {
  my $self = shift;
  return grep { !defined($self->$_) } @locations;
}

sub board_layout {
  my $self = shift;
  my %layout = map { $_ => $self->$_ } @locations;
  return %layout;
}

1;

=head1 TITLE

TicTacToe::Schema::Result::Board - Represents the state of a board of classic TicTacToe

=head1 DESCRIPTION

The row represents the state of a board of Tic Tac Toe at a given point in the
game.  There are nine positions in the board and each of these is represented
by a column in the table.  The layout to column mapping is as follows:

    tl | tc | tr
    == | == | ==
    ml | mc | mr
    == | == | ==
    bl | bm | br

Each column is an enum that can be 'X' or 'O' and the column is nullable.  A new
game board starts with all values null and the X and O players take turns choosing
a column until all columns are filled or a winning condition emerges.

X goes first.

=head1 RELATIONSHIPS

This class defines the following relationships

=head2 game

The game this belongs to.

=head1 METHODS

This class defines the following methods

=head2 whos_turn

It is X or O up?

=head2 available_moves

list of locations a player can legally choose

=head2 board_layout

A hash of the board occupation setup.

=head1 AUTHORS & COPYRIGHT

See L<TicTacToe>.

=head1 LICENSE

See L<TicTacToe>.

=cut
