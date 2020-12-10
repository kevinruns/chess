

# Queen
class Queen < Piece
  attr_accessor :code

  def initialize(colour, position)
    super(colour, position)
    @code = ChessConstants::PIECE_CODES.dig(:QUEEN, colour.to_sym)
  end

  def all_moves(position = @position)
    moves = []
    moves.concat([diag_moves(position, "up", "right")])
    moves.concat([diag_moves(position, "up", "left")])
    moves.concat([diag_moves(position, "down", "right")])
    moves.concat([diag_moves(position, "down", "left")])

    moves.concat([horiz_moves(position, "right")])
    moves.concat([horiz_moves(position, "left")])

    moves.concat([vertical_moves(position, "up")])
    moves.concat([vertical_moves(position, "down")])

    moves
  end

  def horiz_moves(position, horiz)
    h_moves = []
    h_index = horiz == "right" ? 7 - position[1] : position[1]
    i = 0
    while h_index.positive?
      rank = position[0]
      file = horiz == "right" ? position[1] + 1 + i : position[1] - 1 - i
      h_moves[i] = [rank, file]
      i += 1
      h_index -= 1
    end
    h_moves
  end

  def vertical_moves(position, vert)
    v_moves = []
    v_index = vert == "up" ? 7 - position[0] : position[0]
    i = 0
    while v_index.positive? 
      rank = vert == "up" ? position[0] + 1 + i : position[0] - 1 - i
      file = position[1]
      v_moves[i] = [rank, file]
      i += 1
      v_index -= 1
    end
    v_moves
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




  
end

