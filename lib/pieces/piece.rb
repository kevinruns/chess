class Piece
  attr_accessor :colour, :position, :last_position

  def initialize(colour, position)
    @colour = colour
    @position = position
    @initial_position = position
    @last_position = position
  end

  def new_position(new_position)
    @last_position = @position
    @position = new_position
  end

  def last_position
    @position = @last_position
  end


end
