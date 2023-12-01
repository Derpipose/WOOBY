require 'glimmer-dsl-libui'

class Tetris
  include Glimmer

  BLOCK_SIZE = 75
  PLAYER_SIZE = 75
  BEVEL_CONSTANT = 20
  COLOR_DARK_GREY = { r: 50, g: 50, b: 50 }
  COLOR_LIGHT_GREY = { r: 250, g: 250, b: 250 }
  PLAYER_COLOR = { r: 100, g: 150, b: 170 }

  def initialize
    # Remove Tetris game model instantiation
  end

  def launch(board, player_point)
    create_gui(board, player_point)
    @main_window.show
  end

  def create_gui(board, player_point)
    @main_window = window('Derp Catch') {
      content_size board[0].size * BLOCK_SIZE, board.size * BLOCK_SIZE
      resizable false

      vertical_box {
        padded false

        board.each_with_index do |row, x|
          horizontal_box {
            padded false

            row.each_with_index do |element, y|
              if [x + 1, y + 1] == player_point
                block(row: x, column: y, block_size: PLAYER_SIZE, color: PLAYER_COLOR)
              else
                color = element == 'x' ? COLOR_DARK_GREY : COLOR_LIGHT_GREY
                block(row: x, column: y, block_size: BLOCK_SIZE, color: color)
              end
            end
          }
        end
      }
    }
  end

  def block(row:, column:, block_size:, color:)
    bevel_pixel_size = 0.16 * block_size.to_f
    area {
      square(0, 0, block_size) {
        fill color
      }

      # ... Remaining block creation code

      on_key_down do |key_event|
        # ... Remaining key event handling code
      end
    }
  end
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
player_point = [7, 4]

Tetris.new.launch(board, player_point)
