
require_relative '../lib/chess'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/ChessConstants'

require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'


game = Chess.new
game.place_pieces
system 'clear'
puts game.board_obj

# game.move_piece([[1, 3],[3, 3]])
# game.move_piece([[0, 2],[4, 6]])

# puts game.board_obj


while true
  game.move_piece(game.select_and_move(game.player))
  game.change_player
 # system 'clear'
  puts game.board_obj
end

