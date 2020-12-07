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
    it 'expect true' do
      expect(game.board_obj.board).to eq(board_start)
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
