require_relative '../lib/board'
require_relative '../lib/ChessConstants'
require_relative '../lib/chess'
require_relative '../lib/player'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'

describe Chess do
  subject(:game) { Chess.new }

  context 'place pieces in starting position' do
    board_start = []
    before do
      game.place_pieces
      ChessConstants::PLACE_ORDER.each do |piece|
        (board_start[0] ||= []) << ChessConstants::PIECE_CODES.dig(piece, :WHITE)
        (board_start[1] ||= []) << ChessConstants::PIECE_CODES.dig(:PAWN, :WHITE)
        (board_start[2] ||= []) << " "
        (board_start[3] ||= []) << " "
        (board_start[4] ||= []) << " "
        (board_start[5] ||= []) << " "
        (board_start[6] ||= []) << ChessConstants::PIECE_CODES.dig(:PAWN, :BLACK)
        (board_start[7] ||= []) << ChessConstants::PIECE_CODES.dig(piece, :BLACK)
      end
    end
    it 'pieces set up correctly' do
      game.board_obj.board.each_with_index do |_board, i|
        game.board_obj.board[i].each_with_index do |_board, j|
          if i < 2 || i > 5
            expect(game.board_obj.board[i][j].code).to eq(board_start[i][j])
          else
            expect(game.board_obj.board[i][j]).to eq(board_start[i][j])
          end
        end
      end
    end
  end

  context 'move pieces, white only:' do
    before do
      game.place_pieces
      game.move_piece([[1, 3], [3, 3]])
      game.move_piece([[0, 2], [4, 6]])
    end

    it 'pawn allowed moves' do
      piece = game.board_obj.board[3][3]
      expect(game.allowed_moves(piece)).to eq([[4, 3]])
    end

    it 'bishop allowed moves 4 directions' do
      piece = game.board_obj.board[4][6]
      expect(game.allowed_moves(piece)).to eq([[5, 7], [5, 5], [6, 4], [3, 7], [3, 5], [2, 4], [1, 3], [0, 2]])
    end

    it 'bishop allowed moves 1 direction' do
      game.move_piece([[4, 6], [5, 7]])
      piece = game.board_obj.board[5][7]
      expect(game.allowed_moves(piece)).to eq([[6, 6], [4, 6], [3, 5], [2, 4], [1, 3], [0, 2]])
    end

    it 'queen move all directions' do
      game.move_piece([[0, 3], [2, 3]])
      game.move_piece([[2, 3], [4, 1]])
      piece = game.board_obj.board[4][1]
      expect(game.allowed_moves(piece)).to eq([[5, 2], [6, 3], [5, 0], [3, 2], [2, 3], [3, 0],
                                               [4, 2], [4, 3], [4, 4], [4, 5], [4, 0],
                                               [5, 1], [6, 1], [3, 1], [2, 1]])
    end

    it 'knight move from a4' do
      game.move_piece([[0, 1], [2, 2]])
      game.move_piece([[2, 2], [3, 0]])
      piece = game.board_obj.board[3][0]
      expect(game.allowed_moves(piece)).to eq([[5, 1], [4, 2], [2, 2]])
    end
  end


  context 'move pieces, black and white' do

    before do
      game.place_pieces
      game.move_piece([[1, 3], [3, 3]])
      game.move_piece([[0, 2], [4, 6]])
      game.move_piece([[4, 6], [5, 7]])
      game.move_piece([[0, 3], [2, 3]])
      game.move_piece([[2, 3], [4, 1]])
      game.move_piece([[0, 1], [2, 2]])
      game.move_piece([[2, 2], [3, 0]])
      game.move_piece([[6, 3], [4, 3]])
      game.move_piece([[6, 4], [5, 4]])
      game.move_piece([[7, 3], [4, 6]])
      game.move_piece([[7, 1], [5, 2]])
    end

    it 'pawn with no allowed moves' do
      piece = game.board_obj.board[4][3]
      expect(game.allowed_moves(piece)).to eq([])
    end

    it 'pawn with allowed moves' do
      piece = game.board_obj.board[5][4]
      expect(game.allowed_moves(piece)).to eq([[4, 4]])
    end

    it 'queen allowed moves' do
      piece = game.board_obj.board[4][6]
      expect(game.allowed_moves(piece)).to eq([[5, 7], [5, 5], [6, 4], [7, 3], [3, 7], [3, 5],
                                               [2, 4], [1, 3], [0, 2], [4, 7], [4, 5],
                                               [4, 4], [5, 6], [3, 6], [2, 6], [1, 6]])
    end

    it 'knight allowed moves' do
      piece = game.board_obj.board[5][2]
      expect(game.allowed_moves(piece)).to eq([[7, 3], [7, 1], [3, 3], [3, 1], [6, 4], [4, 4], [4, 0]])
    end

    it 'white pawn in taking postion' do
      game.move_piece([[1, 4], [3, 4]])
      piece = game.board_obj.board[3][4]
      expect(game.allowed_moves(piece)).to eq([[4, 4], [4, 3]])
    end

    it 'black pawn in taking postion' do
      game.move_piece([[1, 4], [3, 4]])
      piece = game.board_obj.board[4][3]
      expect(game.allowed_moves(piece)).to eq([[3, 4]])
    end
  end

  context 'test undo' do
    before do
      game.place_pieces
    end

    it 'pawn move and undo' do
      piece = game.board_obj.board[1][3]
      target = game.board_obj.board[3][3]
      game.move_piece([[1, 3], [3, 3]])
      game.undo_move([3, 3])
      expect(game.allowed_moves(piece)).to eq([[2, 3], [3, 3]])
      expect(game.board_obj.board[3][3]).to eq(target)
    end

    it 'take piece and undo' do
      game.move_piece([[1, 3], [3, 3]])
      game.move_piece([[6, 3], [5, 3]])
      game.move_piece([[0, 2], [4, 6]])
      piece = game.board_obj.board[4][6]
      target = game.board_obj.board[6][4]
      game.move_piece([[4, 6], [6, 4]])
      game.undo_move([6, 4])
      expect(game.allowed_moves(piece)).to eq([[5, 7], [5, 5], [6, 4], [3, 7],
                                               [3, 5], [2, 4], [1, 3], [0, 2]])
      expect(game.board_obj.board[6][4]).to eq(target)
    end

  end


  context 'can not move into check' do
    before do
      game.place_pieces
    end

    it 'pawn blocking queen attacking black king' do
      game.move_piece([[1, 4], [3, 4]])
      game.move_piece([[6, 4], [4, 4]])
      game.move_piece([[0, 3], [4, 7]])
      game.black_player
      puts game.board_obj

      piece = game.board_obj.board[6][5]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([])
    end


    it 'knight blocking queen attacking white king' do
      game.move_piece([[1, 4], [3, 4]])
      game.move_piece([[6, 4], [4, 4]])
      game.move_piece([[0, 3], [4, 7]])
      game.move_piece([[6, 3], [5, 3]])
      game.move_piece([[0, 4], [1, 4]])
      game.move_piece([[0, 6], [2, 5]])
      game.move_piece([[7, 2], [3, 6]])
      game.white_player
      piece = game.board_obj.board[2][5]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([])
    end
  end


  context 'test for check' do
    before do
      game.place_pieces
    end

    it 'white queen move to check' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[0, 3], [4, 7]])
      expect(game.B_K.in_check).to eq(true)
    end

    it 'black to get out of check then check white' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[0, 3], [4, 7]])
      game.move_check_change([[6, 6], [5, 6]])
      game.move_check_change([[0, 4], [1, 4]])
      game.move_check_change([[7, 1], [5, 2]])
      game.move_check_change([[1, 2], [2, 2]])
      game.move_check_change([[5, 2], [3, 3]])

      expect(game.W_K.in_check).to eq(true)
    end


    it 'white gets out of check by taking black' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[0, 3], [4, 7]])
      game.move_check_change([[6, 6], [5, 6]])
      game.move_check_change([[0, 4], [1, 4]])
      game.move_check_change([[7, 1], [5, 2]])
      game.move_check_change([[1, 2], [2, 2]])
      game.move_check_change([[5, 2], [3, 3]])
      game.move_check_change([[2, 2], [3, 3]])
      puts game.board_obj

      game.opponent_in_check(game.player.colour)
      expect(game.W_K.in_check).to eq(false)
    end
  end

  context 'test for pawn check' do
    before do
      game.place_pieces
    end

    it 'white pawn advances, king can not move into check' do
      game.move_check_change([[1, 5], [3, 5]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[1, 6], [3, 6]])
      game.move_check_change([[7, 4], [6, 5]])
      game.move_check_change([[3, 5], [4, 5]])

      piece = game.board_obj.board[6][5]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([[7, 4]])
    end

    it 'white pawn advances, king puts king in check diagonally' do
      game.move_check_change([[1, 5], [3, 5]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[1, 6], [3, 6]])
      game.move_check_change([[7, 4], [6, 5]])
      game.move_check_change([[3, 6], [4, 6]])
      game.move_check_change([[5, 5], [4, 6]])
      game.move_check_change([[0, 1], [2, 2]])
      game.move_check_change([[6, 5], [5, 5]])

      expect(game.B_K.in_check).to eq(false)
      game.move_check_change([[3, 5], [4, 6]])
      expect(game.B_K.in_check).to eq(true)
    end

    it 'white pawn advances, in front of king but no check' do
      game.move_check_change([[1, 5], [3, 5]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[1, 6], [3, 6]])
      game.move_check_change([[7, 4], [6, 5]])
      game.move_check_change([[3, 6], [4, 6]])
      game.move_check_change([[5, 5], [4, 6]])
      game.move_check_change([[7, 1], [5, 2]])
      game.move_check_change([[6, 5], [5, 5]])

      expect(game.B_K.in_check).to eq(false)
      game.move_check_change([[3, 5], [4, 5]])
      expect(game.B_K.in_check).to eq(false)
    end


    it 'white pawn advances, king limited moves' do
 
      game.move_check_change([[1, 5], [3, 5]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[1, 6], [3, 6]])
      game.move_check_change([[7, 4], [6, 5]])
      game.move_check_change([[3, 6], [4, 6]])
      game.move_check_change([[5, 5], [4, 6]])
      game.move_check_change([[7, 1], [5, 2]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[3, 5], [4, 5]])

      piece = game.board_obj.board[5][5]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([[6, 5],[4, 5],[4, 4]])
    end
  end


  context 'test for moving pieces' do
    before do
      game.place_pieces
    end

    it 'white king moved' do
      game.move_check_change([[1, 5], [3, 5]])
      game.move_check_change([[6, 5], [5, 5]])
      expect(game.W_K.piece_moved).to eq(false)
      game.move_check_change([[0, 4], [1, 5]])
      expect(game.W_K.piece_moved).to eq(true)
      game.move_check_change([[6, 3], [5, 3]])
      game.move_check_change([[1, 5], [0, 4]])
      expect(game.W_K.piece_moved).to eq(true)
    end

    it 'black king moved' do
      game.move_check_change([[1, 5], [3, 5]])
      game.move_check_change([[6, 5], [5, 5]])
      game.move_check_change([[0, 4], [1, 5]])
      expect(game.B_K.piece_moved).to eq(false)
      game.move_check_change([[7, 4], [6, 5]])
      expect(game.B_K.piece_moved).to eq(true)
    end
  end


  context 'test for castling' do
    before do
      game.place_pieces
    end
  
    # TODO check king allowed moves
    it 'white king castling right' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 3], [5, 3]])
      game.move_check_change([[0, 5], [3, 2]])
      game.move_check_change([[7, 2], [3, 6]])
      game.move_check_change([[0, 6], [2, 5]])
      game.move_check_change([[7, 1], [5, 2]])
      game.move_check_change([[0, 4], [0, 6]])

      piece = game.board_obj.board[0][5]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([[0, 4]])
    end

    it 'black king castling left' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 3], [5, 3]])
      game.move_check_change([[0, 5], [3, 2]])
      game.move_check_change([[7, 2], [3, 6]])
      game.move_check_change([[0, 6], [2, 5]])
      game.move_check_change([[7, 1], [5, 2]])
      game.move_check_change([[0, 4], [0, 6]])
      game.move_check_change([[7, 3], [6, 3]])
      game.move_check_change([[1, 7], [2, 7]])

      game.move_check_change([[7, 4], [7, 2]])

      piece = game.board_obj.board[7][3]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([[7, 4]])
    end


    it 'black king castling right' do
      game.move_check_change([[1, 3], [3, 3]])
      game.move_check_change([[6, 4], [5, 4]])
      game.move_check_change([[0, 2], [3, 5]])
      game.move_check_change([[7, 5], [6, 3]])
      game.move_check_change([[0, 1], [2, 2]])
      game.move_check_change([[7, 6], [5, 5]])
      game.move_check_change([[0, 3], [2, 3]])
      game.move_check_change([[7, 4], [7, 6]])

      piece = game.board_obj.board[7][5]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([[7, 4]])
    end

    it 'white king castling left' do
      game.move_check_change([[1, 3], [3, 3]])
      game.move_check_change([[6, 4], [5, 4]])
      game.move_check_change([[0, 2], [3, 5]])
      game.move_check_change([[7, 5], [6, 3]])
      game.move_check_change([[0, 1], [2, 2]])
      game.move_check_change([[7, 6], [5, 5]])
      game.move_check_change([[0, 3], [2, 3]])
      game.move_check_change([[7, 4], [7, 6]])
      game.move_check_change([[0, 4], [0, 2]])

      piece = game.board_obj.board[0][3]
      valid_moves = game.allowed_moves(piece)
      expect(game.moving_into_check(piece, valid_moves)).to eq([[0, 4], [1, 3]])
    end

  end


  context 'test for check mate' do
    before do
      game.place_pieces
    end
  
    it 'white check mating black queen' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 7], [4, 7]])
      game.move_check_change([[0, 5], [1, 4]])
      game.move_check_change([[6, 6], [4, 6]])
      game.move_check_change([[0, 1], [2, 2]])
      game.move_check_change([[6, 5], [4, 5]])
      game.move_check_change([[1, 4], [4, 7]])
      game.move_check_change([[7, 7], [4, 7]])
      game.move_check_change([[0, 3], [4, 7]])
      expect(game.check_mate(game.player)).to eq(true)
    end

    it 'black check mating white queen' do

      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 4], [4, 4]])
      game.move_check_change([[0, 6], [2, 5]])
      game.move_check_change([[6, 3], [4, 3]])
      game.move_check_change([[3, 4], [4, 3]])
      game.move_check_change([[7, 3], [4, 3]])
      game.move_check_change([[0, 5], [4, 1]])
      game.move_check_change([[4, 3], [4, 1]])
      game.move_check_change([[0, 4], [0, 6]])
      game.move_check_change([[7, 6], [5, 5]])
      game.move_check_change([[0, 5], [0, 4]])
      game.move_check_change([[5, 5], [3, 6]])
      game.move_check_change([[0, 4], [4, 4]])
      game.move_check_change([[7, 5], [6, 4]])
      game.move_check_change([[0, 6], [0, 7]])
      game.move_check_change([[6, 2], [4, 2]])
      game.move_check_change([[1, 2], [2, 2]])
      game.move_check_change([[7, 1], [6, 1]])
      game.move_check_change([[0, 3], [2, 1]])
      game.move_check_change([[4, 1], [0, 5]])
      game.move_check_change([[2, 5], [0, 6]])
      game.move_check_change([[3, 6], [1, 5]])

      puts game.board_obj
      expect(game.check_mate(game.player)).to eq(true)
    end
  end

  context 'pawn moved_two_squares variable tests' do
    before do
      game.place_pieces
    end
  
    it 'moved_two_squares variable not set for white pawn' do
      game.move_check_change([[1, 4], [2, 4]])
      piece = game.board_obj.board[2][4]
      expect(piece.moved_two_squares).to eq(false)
    end

    it 'setting moved_two_squares variable for white pawn' do
      game.move_check_change([[1, 4], [3, 4]])
      piece = game.board_obj.board[3][4]
      expect(piece.moved_two_squares).to eq(true)
    end

    it 'un setting moved_two_squares variable for white pawn' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[3, 4], [4, 4]])
      piece = game.board_obj.board[4][4]
      expect(piece.moved_two_squares).to eq(false)
      puts game.board_obj
    end

    it 'moved_two_squares variable not set for black pawn' do
      game.move_check_change([[6, 1], [5, 1]])
      piece = game.board_obj.board[5][1]
      expect(piece.moved_two_squares).to eq(false)
    end

    it 'setting moved_two_squares variable for black pawn' do
      game.move_check_change([[6, 3], [4, 3]])
      piece = game.board_obj.board[4][3]
      expect(piece.moved_two_squares).to eq(true)
    end

    it 'un setting moved_two_squares variable for black pawn' do
      game.move_check_change([[6, 3], [4, 3]])
      game.move_check_change([[4, 3], [3, 3]])
      piece = game.board_obj.board[3][3]
      expect(piece.moved_two_squares).to eq(false)
      puts game.board_obj
    end
  end

  context 'enpassant_square' do
    before do
      game.place_pieces
    end
  
    it 'un setting moved_two_squares variable for white pawn' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[3, 4], [4, 4]])
      piece = game.board_obj.board[4][4]
      expect(piece.moved_two_squares).to eq(false)
      puts game.board_obj
    end

  end


  context 'pawns taking en passant' do
    before do
      game.place_pieces
    end

    it 'white pawn taking black' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 0], [4, 0]])
      game.move_check_change([[3, 4], [4, 4]])
      game.move_check_change([[6, 3], [4, 3]])
      game.move_check_change([[4, 4], [5, 3]])
      expect(game.board_obj.board[4][3]).to eq(" ")
    end

    it 'black pawn taking white' do
      game.move_check_change([[1, 4], [3, 4]])
      game.move_check_change([[6, 0], [4, 0]])
      game.move_check_change([[1, 3], [3, 3]])
      game.move_check_change([[4, 0], [3, 0]])
      game.move_check_change([[1, 1], [3, 1]])
      game.move_check_change([[3, 0], [2, 1]])
      expect(game.board_obj.board[3][1]).to eq(" ")

      puts game.board_obj
    end


  end





end
