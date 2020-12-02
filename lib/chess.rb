# class with methods to run game
class Chess
  def initialize
    @knight = Knight.new
    @board = Board.new
    @start = [0, 0]
    @target = [0, 0]
  end

  def move_piece(position)
    all_moves = @knight.all_moves(position)
    all_moves.select { |move| onboard(move) && !@board.square_visited(move) }
  end

  def print_board
    @board.print_board
  end

  def onboard(coord)
    coord[0].between?(0, @board.board_size - 1) && coord[1].between?(0, @board.board_size - 1)
  end

  def check_inputs(start, target)
    onboard(start) && onboard(target) && start != target
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
      if node.position == @target
        print "\nCongratulations! The knight has made it to the target. \n"
        print_path(node)
        break
      end
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
