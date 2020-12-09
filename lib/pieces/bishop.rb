
# Bishop
class Bishop < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:BISHOP, colour.to_sym)
  end

  def all_moves(position = @position)
    moves = []

    p moves
    moves.concat(diag_up_right) if diag_up_right.length.positive?
    p moves
    moves.concat(diag_up_left) if diag_up_left.length.positive?
    p moves
    moves.concat(diag_down_right) if diag_down_right.length.positive?
    p moves
    moves.concat(diag_down_left) if diag_down_left.length.positive?
    p moves
    moves
  end

  def diag_up_right
    diag_up_right_moves = []
    top = 7 - position[0]
    right = 7 - position[1]
    i = 0
    while top.positive? && right.positive?
      diag_up_right_moves[i] = [position[0] + 1 + i, position[1] + 1 + i]
      i += 1
      top -= 1
      right -= 1
    end
    diag_up_right_moves
  end

  def diag_up_left
    diag_up_left_moves = []
    top = 7 - position[0]
    bottom = position[0]
    right = 7 - position[1]
    left = position[1]
    i = 0
    while top.positive? && left.positive?
      diag_up_left_moves[i] = [position[0] + 1 + i, position[1] - 1 - i]
      i += 1
      top -= 1
      left -= 1
    end
    diag_up_left_moves
  end

  def diag_down_right
    diag_down_right_moves = []
    bottom = position[0]
    right = 7 - position[1]
    i = 0
    while bottom.positive? && right.positive?
      diag_down_right_moves[i] = [position[0] - 1 - i, position[1] + 1 + i]
      i += 1
      bottom -= 1
      right -= 1
    end
    diag_down_right_moves
  end

  def diag_down_left
    diag_down_left_moves = []
    bottom = position[0]
    left = position[1]
    i = 0
    while bottom.positive? && left.positive?
      diag_down_left_moves[i] = [position[0] - 1 - i, position[1] - 1 - i]
      i += 1
      bottom -= 1
      left -= 1
    end
    diag_down_left_moves
  end

end
