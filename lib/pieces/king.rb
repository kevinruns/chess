
# king
class King < Piece
  attr_accessor :code, :in_check

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:KING, colour.to_sym)
    @in_check = false
  end

  def all_moves(position = @position)
    moves = []
    moves[0] = [[position[0], position[1] + 1]]
    moves[1] = [[position[0], position[1] - 1]]
    moves[2] = [[position[0] + 1, position[1]]]
    moves[3] = [[position[0] - 1, position[1]]]
    moves[4] = [[position[0] + 1, position[1] + 1]]
    moves[5] = [[position[0] + 1, position[1] - 1]]
    moves[6] = [[position[0] - 1, position[1] + 1]]
    moves[7] = [[position[0] - 1, position[1] - 1]]
    moves
  end

  def now_in_check
    @in_check = true
  end

  def out_of_check
    @in_check = false
  end

end
