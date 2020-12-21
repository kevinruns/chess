
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


while true
  position_array = game.select_and_move(game.player)
  game.move_check_change(position_array)
  puts game.board_obj
end

