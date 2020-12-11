
# Rook
class Rook < Queen
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:ROOK, colour.to_sym)
  end

  def all_moves(position = @position)
    moves = []
    moves.concat([horiz_moves(position, "right")])
    moves.concat([horiz_moves(position, "left")])
    moves.concat([vertical_moves(position, "up")])
    moves.concat([vertical_moves(position, "down")])
    moves
  end
end
