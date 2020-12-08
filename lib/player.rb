# connect four player class
class Player
  attr_reader :name, :colour

  def initialize(player_name, colour)
    @name = player_name
    @colour = colour
  end

  def select_move
    gets.chomp
  end

end
