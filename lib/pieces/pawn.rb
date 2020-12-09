# pawns
class Pawn < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:PAWN, colour.to_sym)
  end

  def all_moves(position = @position)
    moves = []
    moves[0] = [position[0] + 1, position[1]]
    if @position == @initial_position
      moves[1] = [position[0] + 2, position[1]]
    end
    moves
  end
end
