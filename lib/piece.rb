

# knight piece
class Knight
  attr_accessor :postiion

  def initialize
    @position = [0, 0]
  end

  def all_moves(position = @position)
    moves = []
    moves[0] = [position[0] + 2, position[1] + 1]
    moves[1] = [position[0] + 2, position[1] - 1]
    moves[2] = [position[0] - 2, position[1] + 1]
    moves[3] = [position[0] - 2, position[1] - 1]
    moves[4] = [position[0] + 1, position[1] + 2]
    moves[5] = [position[0] - 1, position[1] + 2]
    moves[6] = [position[0] + 1, position[1] - 2]
    moves[7] = [position[0] - 1, position[1] - 2]
    moves
  end
end
