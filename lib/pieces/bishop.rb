# Bishop
class Bishop < Queen
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:BISHOP, colour.to_sym)
  end

  def all_moves(position = @position)
    moves = []
    moves.concat([diag_moves(position, "up", "right")])
    moves.concat([diag_moves(position, "up", "left")])
    moves.concat([diag_moves(position, "down", "right")])
    moves.concat([diag_moves(position, "down", "left")])
    moves
  end

end
