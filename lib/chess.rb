# class with methods to run game
class Chess

  attr_reader :board_obj

  def initialize
    @board_obj = Board.new

    @white_pieces = []
    @white_pieces << @W_Q = Queen.new('WHITE', [1, 4])
    @white_pieces << @W_QB = Bishop.new('WHITE', [1, 3])
    @white_pieces << @W_QN = Knight.new('WHITE', [1, 2])
    @white_pieces << @W_QR = Rook.new('WHITE', [1, 1])
    @white_pieces << @W_K = King.new('WHITE', [1, 5])
    @white_pieces << @W_KB = Bishop.new('WHITE', [1, 6])
    @white_pieces << @W_KN = Knight.new('WHITE', [1, 7])
    @white_pieces << @W_KR = Rook.new('WHITE', [1, 8])
    @white_pieces << @W_P1 = Pawn.new('WHITE', [2, 1])
    @white_pieces << @W_P2 = Pawn.new('WHITE', [2, 2])
    @white_pieces << @W_P3 = Pawn.new('WHITE', [2, 3])
    @white_pieces << @W_P4 = Pawn.new('WHITE', [2, 4])
    @white_pieces << @W_P5 = Pawn.new('WHITE', [2, 5])
    @white_pieces << @W_P6 = Pawn.new('WHITE', [2, 6])
    @white_pieces << @W_P7 = Pawn.new('WHITE', [2, 7])
    @white_pieces << @W_P8 = Pawn.new('WHITE', [2, 8])

    @black_pieces = []
    @black_pieces << @B_Q = Queen.new('BLACK', [8, 4])
    @black_pieces << @B_QB = Bishop.new('BLACK', [8, 3])
    @black_pieces << @B_QN = Knight.new('BLACK', [8, 2])
    @black_pieces << @B_QR = Rook.new('BLACK', [8, 1])
    @black_pieces << @B_K = King.new('BLACK', [8, 5])
    @black_pieces << @B_KB = Bishop.new('BLACK', [8, 6])
    @black_pieces << @B_KN = Knight.new('BLACK', [8, 7])
    @black_pieces << @B_KR = Rook.new('BLACK', [8, 8])
    @black_pieces << @B_P1 = Pawn.new('BLACK', [7, 1])
    @black_pieces << @B_P2 = Pawn.new('BLACK', [7, 2])
    @black_pieces << @B_P3 = Pawn.new('BLACK', [7, 3])
    @black_pieces << @B_P4 = Pawn.new('BLACK', [7, 4])
    @black_pieces << @B_P5 = Pawn.new('BLACK', [7, 5])
    @black_pieces << @B_P6 = Pawn.new('BLACK', [7, 6])
    @black_pieces << @B_P7 = Pawn.new('BLACK', [7, 7])
    @black_pieces << @B_P8 = Pawn.new('BLACK', [7, 8])
  end

  def place_pieces
    (@white_pieces + @black_pieces).each do |piece|
      @board_obj.write(piece.position[0], piece.position[1], piece.code)
    end
  end

  def move_piece(piece, position)
    all_moves = piece.all_moves(position)
    all_moves.select { |move| onboard(move) && @board.square_empty(move) }
  end

  def print_board
    @board_obj.print_board
  end

  def onboard(coord)
    coord[0].between?(0, @board_obj.board_size - 1) && coord[1].between?(0, @board_obj.board_size - 1)
  end

  def check_inputs(start, target)
    onboard(start) && onboard(target) && start != target
  end

  # main method for assigning start and target and initiating moves
  def knight_moves(start, target)
    return 0 unless check_inputs(start, target)

    @start = start
    @target = target

    node = Node.new(start, nil)
    find_path([node])
  end

  # find path from start to target
  def find_path(nodes)
    node_array = []

    nodes.each do |node|
      moves = move_piece(node.position)
      parent = node
      moves.each do |new_position|
        node = Node.new(new_position, parent)
        node_array.push(node)
      end
    end

    return if node_array.length == 0

    node_array.each do |node|
      if node.position == @target
        print "\nCongratulations! The knight has made it to the target. \n"
        print_path(node)
        break
      end
    end

    find_path(node_array)
  end

  def print_path(node)
    str = ""
    cnt = 0
    while node.parent
      str.prepend(node.position.to_s).prepend(" -> ")
      node = node.parent
      cnt += 1
    end
    str.prepend(node.position.to_s)
    print "Found in #{cnt} moves: #{str} \n\n"
  end
end

# node
class Node
  attr_accessor :position, :parent

  def initialize(start = [0, 0], parent)
    @position = start
    @parent = parent
  end

end
