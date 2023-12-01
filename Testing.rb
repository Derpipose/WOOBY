
require 'glimmer-dsl-libui'
require 'minitest/autorun'

include Glimmer

class Bird
    attr_reader :positionx, :positiony
    size = 25
    color = {r: 210, g: 210, b:210}
    positionx = 0
    positiony = 0

    def initialize (x, y)
        @positionx = x
        @positiony = y
    end


    ##TODO COMPLETE BIRD RESPONSE
    def move(x, y)
        if x == positionx && y > positiony
            ##COMPLETE THIS
        end
    end

    # puts 'I work!'
end

class Player
    attr_reader :positionx, :positiony

    def initialize (y, x, board)
        @positionx = x
        @positiony = y
        @board = board
    end

    def move(way)
        if way == 'up' && @board[@positiony - 1][@positionx] != 'x'
          @positiony -= 1
        elsif way == 'left' && @board[@positiony][@positionx - 1] != 'x'
          @positionx -= 1
        elsif way == 'right' && @board[@positiony][@positionx + 1] != 'x'
          @positionx += 1
        elsif way == 'down' && @board[@positiony + 1][@positionx] != 'x'
          @positiony += 1
        end
      end

end

class Board
    Chunks = []
    def initialize(layout)
        @Chunks = layout
    end
end

# window('Derp Test').show
# end
class PlayerTest < Minitest::Test
    def test_player_move
        boardtest = [
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
            ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0']
        ]
      player = Player.new(3, 1, boardtest)
      assert_equal(player.positionx, 1)
      assert_equal(player.positiony, 3)
      player.move('down')
      assert_equal(player.positionx, 1)
      assert_equal(player.positiony, 4)
    end
  end


class PlayerBoardTest < Minitest::Test
    def test_Player_Board

        boardtest = [
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
        player = Player.new(2,7,boardtest)
        player.move("right")
        assert_equal(player.positionx, 7)
        assert_equal(player.positiony, 2)
        player.move("left")
        assert_equal(boardtest[7][3], '0')
        assert_equal(player.positionx, 7)
        assert_equal(player.positiony, 3)
    end
end
