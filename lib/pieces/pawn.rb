# pawns
class Pawn < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:PAWN, colour.to_sym)
  end

  def all_moves(position = @position)
    moves = []
    one_square = colour == 'WHITE' ? 1 : -1;
    two_squares = colour == 'WHITE' ? 2 : -2;

    moves[0] = [[position[0] + one_square, position[1]]]
    if @position == @initial_position
      moves[1] = [[position[0] + two_squares, position[1]]]
    else
      moves[1] = []
    end

    # attack moves
    moves[2] = [[position[0] + one_square, position[1] + 1]]
    moves[3] = [[position[0] + one_square, position[1] - 1]]

    moves
  end
end
