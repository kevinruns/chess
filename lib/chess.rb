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

  # for each possible move by playerA piece, check moves of every piece of playerB to see if playerA in check
  def moving_into_check(piece, valid_moves)
    valid_not_in_check = []
    old_position = piece.position

    # for each possible move, try it and test if in check, if so need to delete
    valid_moves.each do |test_position|
      move_piece([old_position, test_position])
      change_player
      if opponent_in_check(player.colour)
        valid_not_in_check.delete(test_position)
        undo_opponent_check(player.colour)
      else
        valid_not_in_check << test_position
      end
      change_player
      undo_move(test_position)
    end
    valid_not_in_check
  end

  def undo_opponent_check(attack_colour)
    if attack_colour == "WHITE"
      @B_K.out_of_check
    elsif attack_colour == "BLACK"
      @W_K.out_of_check
    else
      puts "ERROR"
    end
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

  def allowed_moves(piece)
    moves = piece.all_moves(piece.position)
    valid_squares(moves, piece)
  end

  def select_and_move(player)
    # select piece return nil,[] if check mate
    old_position, move_array = select_piece(player)
    return nil if old_position.nil?

    new_position = select_position(move_array)
    [old_position, new_position]
  end

  def castling_move(position_array)
    case position_array
    when [[0, 4], [0, 2]]
      move_piece([[0, 0], [0, 3]])
    when [[0, 4], [0, 6]]
      move_piece([[0, 7], [0, 5]])
    when [[7, 4], [7, 2]]
      move_piece([[7, 0], [7, 3]])
    when [[7, 4], [7, 6]]
      move_piece([[7, 7], [7, 5]])
    end
  end

  # position array = [old_position, new_position] from select_and_move
  def move_piece(position_array)
    old_position = position_array[0]
    piece_to_move = board_obj.board[old_position[0]][old_position[1]]

    castling_move(position_array) if piece_to_move.instance_of?(King)

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

    board_obj.board[new_position[0]][new_position[1]] = piece_to_move
  end

  # this method makes an array of all allowed moves; for check mate no moves allowed
  def check_mate(player)
    player_pieces = []
    if player.colour == "BLACK"
      player_pieces = @black_pieces
    elsif player.colour == "WHITE"
      player_pieces = @white_pieces
    else
      print "ERROR"
    end

    all_moves = []

    # TODO create seperate function check for check mate
    player_pieces.each do |piece|
      moves = allowed_moves(piece)
      all_moves << moving_into_check(piece, moves)
    end

    if all_moves.flatten.length.zero?
      puts "******** CHECK MATE ********"
      return true
    else
      return false
    end
  end

  # method to select piece to move; returns piece position & possible moves
  # CHANGE IDENTIFY ALL MOVES FIRST. IF NONE CHECK MATE
  def select_piece(player)
    piece = ""
    moves = []

    king = (player.colour == 'WHITE') ? @W_K : @B_K
    if king.in_check && check_mate(player)
      return [nil, []]
    end

    until defined?(piece.colour) && valid_piece?(player, piece) && moves.length.positive?
      piece_input = prompt_for_piece
      piece_pos = format_coords(piece_input)
      rank = piece_pos[0]
      file = piece_pos[1]
      next unless rank.between?(0, 7) && file.between?(0, 7) && @board_obj.board[rank][file] != " "

      piece = @board_obj.board[rank][file]
      moves = allowed_moves(piece)
      moves = moving_into_check(piece, moves)
      moves = add_castling_moves(piece, moves) if piece.instance_of?(King)
    end
    [piece.position, moves]
  end

  def add_castling_moves(piece, valid_moves)
    castling_positions = []

    # already checking for King when called TODO
    if piece.instance_of?(King)
      king_not_moved = !piece.piece_moved
      king_colour = piece.colour
      row = king_colour == 'WHITE' ? 0 : 7

      # left side
      left_empty = board_obj.board[row][1] == " " && board_obj.board[row][2] == " " && board_obj.board[row][3] == " "
      left_not_attacked = !(under_attack([row, 1], king_colour) || under_attack([row, 2], king_colour) || under_attack([row, 3], king_colour))
      left_rook_square = board_obj.board[row][0]
      left_rook_not_moved = defined?(left_rook_square.colour) && !left_rook_square.piece_moved

      castling_positions << [row, 2] if left_empty && left_not_attacked && left_rook_not_moved

      # right side
      right_empty = board_obj.board[row][5] == " " && board_obj.board[row][6] == " "
      right_not_attacked = !(under_attack([row][5], king_colour) || under_attack([row][6], king_colour))
      right_rook_square = board_obj.board[row][7]
      right_rook_not_moved = defined?(right_rook_square.colour) && !right_rook_square.piece_moved

      castling_positions << [row, 6] if right_empty && right_not_attacked && right_rook_not_moved
    end

    valid_moves.concat(castling_positions) if castling_positions.length > 0
    valid_moves
  end

  def under_attack(castling_square, king_colour)
    attack_pieces = []
    if king_colour == 'WHITE'
      attack_pieces = @black_pieces
    elsif king_colour == 'BLACK'
      attack_pieces = @white_pieces
    end

    attack_pieces.each do |piece|
      moves = allowed_moves(piece)
      moves.select! { |move| move[1] != piece.position[1] } if piece.instance_of?(Pawn)
      return true if moves&.length.positive? && moves.include?(castling_square)
    end
    false
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
    if piece.colour == "WHITE"
      #      print "Black takes White #{piece.class} \n"
      @white_pieces.delete(piece)
    elsif piece.colour == "BLACK"
      #      print "White takes Black #{piece.class} \n"
      @black_pieces.delete(piece)
    end
    @removed_piece = piece
  end

  # method to test if opponent is in check
  def opponent_in_check(attacking_colour)
    attack_pieces = []
    if attacking_colour == "BLACK"
      king_under_attack = @W_K
      attack_pieces = @black_pieces
    elsif attacking_colour == "WHITE"
      king_under_attack = @B_K
      attack_pieces = @white_pieces
    else
      print "ERROR"
    end

    attack_pieces.each do |piece|
      moves = allowed_moves(piece)
      moves.select! { |move| move[1] != piece.position[1] } if piece.instance_of?(Pawn)
      if moves&.length.positive? && moves.include?(king_under_attack.position)
        king_under_attack.now_in_check
#        puts "CHECK MATE" if check_for_mate(attacking_colour)
        return true
      end
    end
    king_under_attack.out_of_check
    false
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

  def change_player
    @player = @player == @white_player ? @black_player : @white_player
  end

  def white_player
    @player = @white_player
  end

  def black_player
    @player = @black_player
  end

  def opponent_colour(player)
    player == @white_player ? 'BLACK' : 'WHITE'
  end

  # move piece; check for check; change player
  def move_check_change(position_array)
    move_piece(position_array)
    puts "#{opponent_colour(player)} KING IN CHECK!" if opponent_in_check(player.colour)
    change_player
#    check_for_mate(player.colour)
  end
end
