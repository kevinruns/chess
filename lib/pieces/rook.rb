
# Rook
class Rook < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:ROOK, colour.to_sym)
  end


end
