# Bishop
class Bishop < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:BISHOP, colour.to_sym)
  end

  def all_moves(_position = @position)
    moves = []

#    moves << diag_up_right if diag_up_right.length.positive?
    up_right_moves = diag_moves(position, "up", "right")
    moves << up_right_moves if up_right_moves.length.positive?

    moves << diag_up_left if diag_up_left.length.positive?
    moves << diag_down_right if diag_down_right.length.positive?
    moves << diag_down_left if diag_down_left.length.positive?
    moves
  end

  def diag_moves(position, vert, horiz)
    diag_moves = []

    v_index = vert == "up" ? 7 - position[0] : position[0]
    h_index = horiz == "right" ? 7 - position[1] : position[1]

    i = 0
    while v_index.positive? && h_index.positive?
      rank = vert == "up" ? position[0] + 1 + i : position[0] - 1 - i
      file = horiz == "right" ? position[1] + 1 + i : position[1] - 1 - i
      diag_moves[i] = [rank, file]

      i += 1
      v_index -= 1
      h_index -= 1
    end
    diag_moves
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
