
module ChessConstants

  BOARD_COLOURS = {
    DARK: '#99CC33',
    LIGHT: '#669966'
  }.freeze

  PIECE_CODES = {
    KING: { WHITE: "\u2654", BLACK: "\u265A" },
    QUEEN: { WHITE: "\u2655", BLACK: "\u265B" },
    BISHOP: { WHITE: "\u2657", BLACK: "\u265D" },
    KNIGHT: { WHITE: "\u2658", BLACK: "\u265E" },
    ROOK: { WHITE: "\u2656", BLACK: "\u265C" },
    PAWN: { WHITE: "\u2659", BLACK: "\u265F" }
  }

  PLACE_ORDER = %i[ROOK KNIGHT BISHOP QUEEN KING BISHOP KNIGHT ROOK].freeze

end
