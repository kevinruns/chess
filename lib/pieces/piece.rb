class Piece
  attr_accessor :colour, :position

  def initialize(colour, position)
    @colour = colour
    @position = position
    @initial_position = position
  end
end
