require_relative '../lib/board'
require_relative '../lib/ChessConstants'
require_relative '../lib/chess'
require_relative '../lib/player'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
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

  context 'move pieces' do
    board_start = []
    before do
      game.place_pieces
      game.move_piece([[1, 3], [3, 3]])
      game.move_piece([[0, 2], [4, 6]])
#      puts game.board_obj
    end

    it 'check pawn allowed moves' do
      piece = game.board_obj.board[3][3]
      expect(game.allowed_moves(piece)).to eq([[4, 3]])
    end

    it 'check bishop allowed moves 4 directions' do
      piece = game.board_obj.board[4][6]
      expect(game.allowed_moves(piece)).to eq([[5, 7], [5, 5], [3, 7], [3, 5], [2, 4], [1, 3], [0, 2]])
    end

    it 'check bishop allowed moves 1 direction' do
      game.move_piece([[4, 6], [5, 7]])
      piece = game.board_obj.board[5][7]
      expect(game.allowed_moves(piece)).to eq([[4, 6], [3, 5], [2, 4], [1, 3], [0, 2]])
    end

    it 'check queen move all directions' do
      game.move_piece([[0, 3], [2, 3]])
      game.move_piece([[2, 3], [4, 1]])
      piece = game.board_obj.board[4][1]
      expect(game.allowed_moves(piece)).to eq([[5, 2], [5, 0], [3, 2], [2, 3], [3, 0],
                                               [4, 2], [4, 3], [4, 4], [4, 5], [4, 0],
                                               [5, 1], [3, 1], [2, 1]])
    end


  end










  # describe '#placing pieces' do
  #   context 'write red to column 1' do
  #     before do
  #       allow(player_one).to receive(:prompt_player).and_return(nil)
  #       allow(player_one).to receive(:select_column).and_return(1)
  #       allow(player_two).to receive(:prompt_player).and_return(nil)
  #       allow(player_two).to receive(:select_column).and_return(1)
  #     end

  #     it '1 red to column 1' do
  #       red_in_col_1x1 = [[blank, blank, blank, blank, blank, blank, blank],
  #                         [blank, blank, blank, blank, blank, blank, blank],
  #                         [blank, blank, blank, blank, blank, blank, blank],
  #                         [blank, blank, blank, blank, blank, blank, blank],
  #                         [blank, blank, blank, blank, blank, blank, blank],
  #                         [red, blank, blank, blank, blank, blank, blank]]

  #       game_board.write_column(player_one)
  #       expect(game_board.board).to eq(red_in_col_1x1)
  #     end
  #   end
  # end
end
