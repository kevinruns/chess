require 'paint'

# chess board
class Board
  attr_accessor :board, :board_size

  def initialize
    @board_size = 8
    @board = Array.new(@board_size) { Array.new(@board_size, " ") }
  end

  def write(rank, file, code)
    @board[rank - 1][file - 1] = code
  end

  def square_empty(coord)
    rank = coord[0]
    file = coord[1]
    @board[rank - 1][file - 1] == ' '
  end

  def to_s
    str = "\n"
    @board.each_with_index do |_row, i|
      str << "      #{8-i} "
      @board[i].each_with_index do |_col, j|
        bg_select = (i + j).even? ? :DARK : :LIGHT
        bg_colour = ChessConstants::BOARD_COLOURS[bg_select]
        fg_colour = "black"
        str << Paint[" #{@board[7 - i][j]}  ", :bold, fg_colour, bg_colour]
      end
      str << "\n"
    end
    str << "\n"
    str
  end

end

