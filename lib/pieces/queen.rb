

# Queen
class Queen < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:QUEEN, colour.to_sym)
  end




  
end

