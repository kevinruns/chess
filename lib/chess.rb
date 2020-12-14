# class with methods to run game
class Chess
  attr_reader :board_obj, :player, :white_pieces, :black_pieces, :W_K, :B_K

  def initialize
    @board_obj = Board.new
    @white_player = Player.new("White", "WHITE")
    @black_player = Player.new("Black", "BLACK")

    @player = @white_player

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

    @piece_taken = false
    @removed_piece = ""
  end

  def prompt_for_piece
    print "#{@player.name} piece to move: "
    gets.chomp
  end

  def prompt_move_square
    print "#{@player.name} where to move: "
    gets.chomp
  end

  def place_pieces
    (@white_pieces + @black_pieces).each do |piece|
      @board_obj.write(piece.position[0], piece.position[1], piece)
    end
  end

  # after move by playerA, check every piece of playerB to see if playerA in check
  def moving_into_check(piece, valid_squares)

    valid_not_in_check = []
    old_position = piece.position

    # for each possible move, try it and test if in check, if so need to delete
    p "valid squares: #{valid_squares}"
    valid_squares.each do |test_position|
      move_piece([old_position, test_position])
      if check_for_check(piece.colour)
        valid_not_in_check.delete(test_position)
      else
        valid_not_in_check << test_position
      end
      undo_move(test_position)
    end
    valid_not_in_check
  end

  def undo_move(undo_position)

    piece = board_obj.board[undo_position[0]][undo_position[1]]

    if @piece_taken
      board_obj.board[piece.position[0]][piece.position[1]] = @removed_piece
      if @removed_piece.colour == 'WHITE'
        @white_pieces << @removed_piece
      elsif @removed_piece.colour == 'BLACK'
        @black_pieces << @removed_piece
      else
        puts "ERROR"
      end
    else
      board_obj.board[piece.position[0]][piece.position[1]] = " "
    end

    # revert piece position
    piece.last_position
    # update board
    board_obj.board[piece.position[0]][piece.position[1]] = piece

  end


  # can not move into check, add check_test to prevent infinite loop
  # can remove move_into_check_test if caller method works
  def allowed_moves(piece)

    caller_method = caller_locations.first.label
    move_array = piece.all_moves(piece.position)
#    p "move array: #{move_array}"
    valid_squares = valid_squares(move_array, piece)
#    p "valid_squares: #{valid_squares}"
    valid_squares = moving_into_check(piece, valid_squares) if caller_method == 'select_piece'
#    p "valid_squares2: #{valid_squares}"

    valid_squares
  end

  # MOVE FUNCTION : Calls many others;   NEED TO ADD PLAYER
  def select_and_move(player)
    old_position, move_array = select_piece(player)
    new_position = select_position(move_array)
    [old_position, new_position]
  end

  # position array = [old_position, new_position] from select_and_move
  def move_piece( position_array )

    old_position = position_array[0]
    piece_to_move = board_obj.board[old_position[0]][old_position[1]]
    board_obj.board[old_position[0]][old_position[1]] = " "

    new_position = position_array[1]
    piece_to_move.new_position(new_position)
    new_square = board_obj.board[new_position[0]][new_position[1]]

    if new_square != " "
      remove_piece(new_square)
      @piece_taken = true
    else
      @piece_taken = false
    end

#   tidy up below; chanage to new_square
    board_obj.board[new_position[0]][new_position[1]] = piece_to_move
  end

  def change_player
    @player = (@player == @white_player) ? @black_player : @white_player
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



  # valid moves, onboard, and not blocked
  def valid_squares(move_array, piece)
    new_move_array = []
    move_array.each do |direction_array|

      # check coords on board
      direction_array.select! { |coord| (coord[0].between?(0, 7) && coord[1].between?(0, 7)) }

      # valid moves blocked by pieces and add valid attack squares
      direction_array.each do |move_square|
        square = @board_obj.board[move_square[0]][move_square[1]]

        if piece.instance_of?(Pawn)

          # case for pawn side takes
          if piece.position[1] != move_square[1]
            if square != " "
              new_move_array << move_square if square.colour != piece.colour
            end
            break
          # case if piece in way
          elsif square != " "
            break
          end

        elsif square != " "
          new_move_array << move_square if square.colour != piece.colour
          break
        end

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

  def remove_piece(piece)
    p "colour of piece to remove: #{piece.colour}"
    if (piece.colour == "WHITE")
      print "Black takes White #{piece.class} \n"
      @white_pieces.delete(piece)
    elsif (piece.colour == "BLACK")
      print "White takes Black #{piece.class} \n"
      @black_pieces.delete(piece)
    end
    @removed_piece = piece
  end

  def check_for_check(colour)
    king = ""
    test_pieces = []
    if colour == "WHITE"
      king = @W_K
      test_pieces = @black_pieces
    elsif colour == "BLACK"
      king = @B_K
      test_pieces = @white_pieces
    end

    test_pieces.each do |piece|
      moves = allowed_moves(piece)
      # p "#{piece.colour}  #{piece.class}"
      # p moves
      if moves && moves.length.positive? && moves.include?(king.position)
        p "Can't move into check"
        return true
      end
    end

    return false

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
