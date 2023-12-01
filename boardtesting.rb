def parse_board(board)
  coordinates = []

  board.each_with_index do |row, x|
    row.each_with_index do |element, y|
      coordinates << [x + 1, y + 1] if element == '0'
    end
  end

  coordinates
end

# Board initial
board = [
  ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
  ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
  ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
  ['x', 'x', 'x', 'x', 'x', '0', 'x', '0', 'x', 'x'],
  ['x', 'x', 'x', 'x', '0', '0', '0', '0', '0', 'x'],
  ['x', 'x', 'x', 'x', 'x', 'x', 'x', '0', 'x', 'x'],
  ['x', '0', '0', '0', '0', '0', '0', '0', '0', 'x'],
  ['x', 'x', 'x', '0', 'x', 'x', 'x', 'x', 'x', 'x'],
  ['x', 'x', 'x', '0', 'x', 'x', 'x', 'x', 'x', 'x'],
  ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x']
]

coordinates = parse_board(board)
puts coordinates.inspect
