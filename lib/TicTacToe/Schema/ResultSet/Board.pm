use strict;
use warnings;

package TicTacToe::Schema::ResultSet::Board;

use base 'TicTacToe::Schema::ResultSet';

sub last_in_game {
  my $self = shift;
  $self->order_by({ -desc => 'move' })->first;
}

sub all_moves {
  my $self = shift;
  $self->order_by('move')->hri->all;
}

1;

=head1 TITLE

TicTacToe::Schema::ResultSet::Board - resultset method for Board

=head1 DESCRIPTION

    TBD

=head1 METHODS

This class defines the following methods

=head2 TBD

    TBD

=head1 AUTHORS & COPYRIGHT

See L<TicTacToe>.

=head1 LICENSE

See L<TicTacToe>.

=cut
