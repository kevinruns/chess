require_relative '../lib/board'
require_relative '../lib/ChessConstants'
require_relative '../lib/chess'
# require_relative '../lib/main'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'

empty_board = [[" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "],
               [" ", " ", " ", " ", " ", " ", " ", " "]]

describe Board do
  subject(:game_board) { Board.new }
  describe '#read_board' do
    context 'empty board' do
      it 'expect true' do
        expect(game_board.board).to eq(empty_board)
      end
    end

    describe '#write_board' do
      context 'single pawn' do
        it 'expect true' do
          pawn1_board = Marshal.load(Marshal.dump(empty_board))
          pawn1_board[2][6] = ChessConstants::PIECE_CODES.dig(:PAWN, :WHITE)
          game_board.write(3, 7, ChessConstants::PIECE_CODES.dig(:PAWN, :WHITE))
          expect(game_board.board).to eq(pawn1_board)
        end
      end
    end

    describe '#square empty' do
      context 'test for empty' do
        it 'expect true' do
          game_board.write(8, 5, ChessConstants::PIECE_CODES.dig(:PAWN, :WHITE))
          expect(game_board.square_empty([8, 5])).to eq(false)
        end
      end

      context 'test for not empty' do
        it 'expect true' do
          game_board.write(8, 4, ChessConstants::PIECE_CODES.dig(:PAWN, :WHITE))
          expect(game_board.square_empty([8, 5])).to eq(true)
        end
      end

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
