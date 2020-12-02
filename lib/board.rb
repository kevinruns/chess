# chess board
class Board
  attr_accessor :board, :board_size

  def initialize
    @board_size = 8
    @board = Array.new(@board_size) { Array.new(@board_size, '-') }
  end

  def square_visited(coord)
    rank = coord[0]
    file = coord[1]
    return true if @board[rank][file] == 'x'

    @board[rank][file] = 'x'
    false
  end

  def print_board
    print "\n"
    @board.each_with_index do |_row, i|
      print '    '
      @board[i].each_with_index do |_col, j|
        print " #{@board[i][j]} "
      end
      print "\n"
    end
    print "\n"
  end
end

