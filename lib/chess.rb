# class with methods to run game
class Chess
  attr_reader :board_obj

  def initialize
    @board_obj = Board.new
    @player_one = Player.new("player_one", "WHITE")

    @white_pieces = []
    @white_pieces << @W_Q = Queen.new('WHITE', [0, 3])
    @white_pieces << @W_QB = Bishop.new('WHITE', [0, 2])
    @white_pieces << @W_QN = Knight.new('WHITE', [0, 1])
    @white_pieces << @W_QR = Rook.new('WHITE', [0, 0])
    @white_pieces << @W_K = King.new('WHITE', [0, 4])
    @white_pieces << @W_KB = Bishop.new('WHITE', [0, 5])
    @white_pieces << @W_KN = Knight.new('WHITE', [0, 6])
    @white_pieces << @W_KR = Rook.new('WHITE', [0, 7])
    @white_pieces << @W_P1 = Pawn.new('WHITE', [1, 0])
    @white_pieces << @W_P2 = Pawn.new('WHITE', [1, 1])
    @white_pieces << @W_P3 = Pawn.new('WHITE', [1, 2])
    @white_pieces << @W_P4 = Pawn.new('WHITE', [1, 3])
    @white_pieces << @W_P5 = Pawn.new('WHITE', [1, 4])
    @white_pieces << @W_P6 = Pawn.new('WHITE', [1, 5])
    @white_pieces << @W_P7 = Pawn.new('WHITE', [1, 6])
    @white_pieces << @W_P8 = Pawn.new('WHITE', [1, 7])

    @black_pieces = []
    @black_pieces << @B_Q = Queen.new('BLACK', [7, 3])
    @black_pieces << @B_QB = Bishop.new('BLACK', [7, 2])
    @black_pieces << @B_QN = Knight.new('BLACK', [7, 1])
    @black_pieces << @B_QR = Rook.new('BLACK', [7, 0])
    @black_pieces << @B_K = King.new('BLACK', [7, 4])
    @black_pieces << @B_KB = Bishop.new('BLACK', [7, 5])
    @black_pieces << @B_KN = Knight.new('BLACK', [7, 6])
    @black_pieces << @B_KR = Rook.new('BLACK', [7, 7])
    @black_pieces << @B_P1 = Pawn.new('BLACK', [6, 0])
    @black_pieces << @B_P2 = Pawn.new('BLACK', [6, 1])
    @black_pieces << @B_P3 = Pawn.new('BLACK', [6, 2])
    @black_pieces << @B_P4 = Pawn.new('BLACK', [6, 3])
    @black_pieces << @B_P5 = Pawn.new('BLACK', [6, 4])
    @black_pieces << @B_P6 = Pawn.new('BLACK', [6, 5])
    @black_pieces << @B_P7 = Pawn.new('BLACK', [6, 6])
    @black_pieces << @B_P8 = Pawn.new('BLACK', [6, 7])
  end

  def prompt_for_piece
    print "#{@name} enter square coords of piece to move: "
    gets.chomp
  end

  def prompt_move_square
    print "#{@name} enter square coords of where to move: "
    gets.chomp
  end

  def place_pieces
    (@white_pieces + @black_pieces).each do |piece|
      @board_obj.write(piece.position[0], piece.position[1], piece)
    end
  end

  # MOVE FUNCTION : Calls many others;   NEED TO ADD PLAYER
  def select_and_move
    old_position, move_array = select_piece(@player_one)
    new_position = select_position(move_array)
    [old_position, new_position]
  end

  def move_piece( position_array )
    old_position = position_array[0]
    new_position = position_array[1]
    piece = board_obj.board[old_position[0]][old_position[1]]
    board_obj.board[old_position[0]][old_position[1]] = " "
    piece.position = new_position
    board_obj.board[new_position[0]][new_position[1]] = piece
  end

  # method to select piece to move; returns piece position & possible moves
  def select_piece(player)
    piece = ""
    move_array = []
    until defined?(piece.colour) && valid_piece?(player, piece) && move_array.length.positive?
      piece_input = prompt_for_piece
      piece_pos = format_coords(piece_input)
      rank = piece_pos[0]
      file = piece_pos[1]
      next unless rank.between?(0, 7) && file.between?(0, 7) && @board_obj.board[rank][file] != " "

      piece = @board_obj.board[rank][file]
      move_array = allowed_moves(piece)

    end
    [piece.position, move_array]
  end

  ####  NEXT WORK; CHECK MOVES ON BOARD; MULTI SQUARE MOVES
  def allowed_moves(piece)
    move_array = piece.all_moves(piece.position)
    square_onboard_empty(move_array)
  end

  def square_onboard_empty(move_array)
    new_move_array = []
    move_array.each do |direction_array|
      direction_array.select { |coord| coord[0].between?(0, 7) && coord[1].between?(0, 7) }
      direction_array.each do |move_square|
        break if @board_obj.board[move_square[0]][move_square[1]] != " "

        new_move_array << move_square
      end
    end
    new_move_array
  end

  def valid_piece?(player, piece)
    player.colour == piece.colour
  end

  def select_position(move_array)
    position = 0
    until move_array.include?(position)
      position_str = prompt_move_square
      position = format_coords(position_str)
    end
    position
  end

  def format_coords(coords)
    coord_array = coords.split('')
    letter = coord_array[0]
    file = letter.count("a-h").positive? ? letter.ord - 97 : -1
    rank = coord_array[1].to_i.between?(1, 8) ? coord_array[1].to_i - 1 : -1
    [rank, file]
  end


  def print_board
    @board_obj.print_board
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
      next unless node.position == @target

      print "\nCongratulations! The knight has made it to the target. \n"
      print_path(node)
      break
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
