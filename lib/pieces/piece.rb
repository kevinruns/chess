class Piece
  attr_accessor :colour, :position, :last_position, :piece_moved

  def initialize(colour, position)
    @colour = colour
    @position = position
    @initial_position = position
    @last_position = position
    @piece_moved = false
  end

  def new_position(new_position)
    @last_position = @position
    @position = new_position
    @piece_moved = true
  end

  def last_position
    @position = @last_position
  end

end
