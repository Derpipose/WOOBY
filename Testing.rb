require 'glimmer-dsl-libui'
require 'minitest/autorun'

include Glimmer

class Bird
    attr_reader :positioncol, :positionrow, :caught

    def initialize (x, y, board)
        @positionrow = x
        @positioncol = y
        @board = board
        @caught = false
    end

    def checkUp
        checkrow = @positionrow
        checkcol = @positioncol
        while @board[checkrow][checkcol] == '0'  do
            if @board[checkrow -1][checkcol-1] == '0' || @board[checkrow-1][checkcol +1] == '0'

                return  true
            end
            checkrow -=1
        end
        return false
    end

    def checkDown
        checkrow = @positionrow
        checkcol = @positioncol
        while @board[checkrow][checkcol] == '0' do
            if @board[checkrow +1][checkcol-1] == '0' || @board[checkrow+1][checkcol +1] == '0'
                movedown = true
                movecomplete = true
            end
            checkrow +=1
        end
    end

    def checkLeft
        checkrow = @positionrow
        checkcol = @positioncol
        while @board[checkrow][checkcol] == '0' do
            if @board[checkrow-1][checkcol -1] == '0' || @board[checkrow+1][checkcol -1] == '0'

                return true
            end
            checkcol -=1
        end
        return false
    end

    def checkRight
        checkrow = @positionrow
        checkcol = @positioncol
        while @board[checkrow][checkcol] == '0' do
            if @board[checkrow-1][checkcol +1] == '0' || @board[checkrow+1][checkcol +1] == '0'
                return true
            end
            checkcol +=1
        end
        return false
    end


    ##TODO COMPLETE BIRD RESPONSE
    def movecheck(row, col)
        if row == @positionrow && col == positioncol
            @caught = true;
        end
        #player approaching from left
        if row == positionrow && col < positioncol && ( positioncol - col <=2 )
            movecomplete = false
            #move right
            if checkRight == true
                @positioncol += 1
                movecomplete = true
            end

            #move up
            if checkUp == true && movecomplete == false
                @positionrow -= 1
                movecomplete = true
            end
            # move down
            if checkDown == true && movecomplete == false
                @positionrow += 1
                movecomplete = true
            end

            #last ditch moving check
            if movecomplete == false
                if @board[@positionrow][@positioncol+1] == '0'
                    @positioncol += 1;
                elsif @board[@positionrow-1][@positioncol] == '0'
                    @positionrow -=1;
                elsif @board[@positionrow +1][@positioncol] == '0'
                    @positionrow +=1;
                end
            end
         #player approaching from bottom
        elsif row > @positionrow && col == @positioncol &&  row - @positionrow <= 2
            movecomplete = false
            #check up

            if  checkUp == true
                @positionrow -= 1
                movecomplete = true
            end
            #check left
            if checkLeft == true && movecomplete == false
                @positioncol -= 1
                movecomplete = true
            end

            # check right
            if checkRight == true && movecomplete == false
                @positioncol += 1
                movecomplete = true
            end
            #last ditch moving check
            if movecomplete == false
                if @board[@positionrow + 1][@positioncol] == '0'
                    @positionrow += 1;
                elsif @board[@positionrow][@positioncol-1] == '0'
                    @positioncol -=1;
                elsif @board[@positionrow][@positioncol+1] == '0'
                    @positioncol +=1;
                end
            end
        #player approaching from right
        elsif row == positionrow && col > positioncol && ( col - positioncol <=2 )
            movecomplete = false
            #check left
            if checkLeft == true
                @positioncol -= 1
                movecomplete = true
            end

            #check down
            if checkDown == true && movecomplete == false
                @positionrow += 1
                movecomplete = true
            end
            # check up
            if checkUp == true && movecomplete == false
                @positionrow -= 1
            end

            #last ditch moving check
            if movecomplete == false
                if @board[@positionrow][@positioncol-1] == '0'
                    @positioncol -= 1;
                elsif @board[@positionrow+1][@positioncol] == '0'
                    @positionrow +=1;
                elsif @board[@positionrow-1][@positioncol] == '0'
                    @positionrow -=1;
                end
            end
        #player approaching from top
        elsif row < @positionrow && col == @positioncol && ( @positionrow - row <=2 )
            movecomplete = false
            #check down
            if checkDown == true
                @positionrow += 1
                movecomplete = true
            end

            #check right
            if checkRight == true && movecomplete == false
                @positioncol += 1
                movecomplete = true
            end
            # check left
            if checkLeft == true && movecomplete == false
                @positioncol -= 1
            end

            #last ditch moving check
            if movecomplete == false
                if @board[@positionrow][@positioncol-1] == '0'
                    @positioncol -= 1;
                elsif @board[@positionrow+1][@positioncol] == '0'
                    @positionrow +=1;
                elsif @board[@positionrow-1][@positioncol] == '0'
                    @positionrow -=1;
                end
            end


        end

    end


    def checkCaught(player)
        if player.positioncol ==positioncol && player.positionrow == positionrow
                @caught = true
        end
    end

end

class Player
    attr_reader :positionrow, :positioncol

    def initialize (x, y, board)
        @positionrow = x
        @positioncol = y
        @board = board
    end

    def move(way)
        if way == 'up' && @board[@positionrow - 1][@positioncol] == '0'
          @positionrow -= 1
        elsif way == 'down' && @board[@positionrow + 1][@positioncol] == '0'
          @positionrow += 1
        elsif way == 'left' && @board[@positionrow][@positioncol - 1] == '0'
          @positioncol -= 1
        elsif way == 'right' && @board[@positionrow][@positioncol + 1] == '0'
          @positioncol += 1
        end
    end

end

class Board
    attr_reader :layout
    def initialize(layout, player, bird)
        @layout = layout
        @player = player
        @bird = bird
    end

    def movep(way)
        if way == 'up'
            @player.move('up')
            @bird.movecheck(@player.positionrow, @player.positioncol)
        elsif way == 'down'
            @player.move('down')
            @bird.movecheck(@player.positionrow, @player.positioncol)
        elsif way == 'left'
            @player.move('left')
            @bird.movecheck(@player.positionrow, @player.positioncol)
        elsif way == 'right'
            @player.move('right')
            @bird.movecheck(@player.positionrow, @player.positioncol)
      end
  end
end

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
      player = Player.new(1, 3, boardtest)
      assert_equal(player.positionrow, 1)
      assert_equal(player.positioncol, 3)
      player.move('down')
      assert_equal(player.positionrow, 2)
      assert_equal(player.positioncol, 3)
      player.move('left')
      assert_equal(player.positionrow, 2)
      assert_equal(player.positioncol, 2)
      player.move('up')
      assert_equal(player.positionrow, 1)
      assert_equal(player.positioncol, 2)
      player.move('right')
      assert_equal(player.positionrow, 1)
      assert_equal(player.positioncol, 3)
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
        player = Player.new(6,1,boardtest)
        player.move("left")
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 1)
        player.move("right")
        # assert_equal(boardtest[6][3], '0')
        assert_equal(boardtest[6][2], '0')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 2)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 3)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 4)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 5)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 6)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 7)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 8)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 8)
        player.move('right')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 8)
        player.move('up')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 8)
        player.move('down')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 8)
        player.move('left')
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 7)
    end
end

class BirdBoardTest < Minitest::Test
    def test_Bird_Board
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
        player = Player.new(6,1,boardtest)
        bird = Bird.new(6,7, boardtest)
        player.move("right")
        player.move("right")
        player.move("right")
        player.move("right")
        player.move("right")
        player.move("right")
        assert_equal(bird.positionrow, 6)
        assert_equal(bird.positioncol, 7)
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 7)
        bird.checkCaught(player)
        assert_equal(true, bird.caught)
    end
end


class BirdMoveResponseTest < Minitest::Test
    def test_Bird_Board
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
        player = Player.new(6,1,boardtest)
        bird = Bird.new(6,7, boardtest)
        player.move("right")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(bird.positionrow, 6)
        assert_equal(bird.positioncol, 7)
        player.move("right")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(bird.positionrow, 6)
        assert_equal(bird.positioncol, 7)
        player.move("right")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(bird.positionrow, 6)
        assert_equal(bird.positioncol, 7)
        player.move("right")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(bird.positionrow, 5)
        assert_equal(bird.positioncol, 7)
        player.move("right")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(bird.positionrow, 5)
        assert_equal(bird.positioncol, 7)
        player.move("right")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(bird.positionrow, 4)
        assert_equal(bird.positioncol, 7)
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 7)
        player.move("up")
        bird.movecheck(player.positionrow, player.positioncol)
        assert_equal(player.positionrow, 5)
        assert_equal(player.positioncol, 7)
        assert_equal(bird.positionrow, 4)
        assert_equal(bird.positioncol, 6)

    end
end

class BoardTesting < Minitest::Test
    def test_Bird_Board
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
        player = Player.new(6,1,boardtest)
        bird = Bird.new(6,7, boardtest)
        game = Board.new(boardtest, player, bird)
        game.movep("right")
        game.movep("right")
        game.movep("right")
        game.movep("right")
        game.movep("right")
        game.movep("right")
        assert_equal(bird.positionrow, 4)
        assert_equal(bird.positioncol, 7)
        assert_equal(player.positionrow, 6)
        assert_equal(player.positioncol, 7)
        game.movep("up")
        assert_equal(player.positionrow, 5)
        assert_equal(player.positioncol, 7)
        assert_equal(bird.positionrow, 4)
        assert_equal(bird.positioncol, 6)
        game.movep("up")
        assert_equal(player.positionrow, 4)
        assert_equal(player.positioncol, 7)
        assert_equal(bird.positionrow, 4)
        assert_equal(bird.positioncol, 5)
        game.movep("left")
        game.movep("left")
        game.movep("left")
        assert_equal(bird.caught, true)

    end
end

class BoardTesting < Minitest::Test
    def test_Bird_Board
        boardtest = [
            ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
            ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', '0', 'x'],
            ['x', '0', 'x', 'x', '0', '0', '0', '0', '0', 'x'],
            ['x', '0', 'x', 'x', '0', 'x', 'x', '0', 'x', 'x'],
            ['x', '0', '0', '0', '0', '0', 'x', '0', 'x', 'x'],
            ['x', 'x', 'x', 'x', '0', 'x', 'x', '0', 'x', 'x'],
            ['x', 'x', 'x', 'x', '0', '0', '0', '0', 'x', 'x'],
            ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
            ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
            ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x']
        ]
        player = Player.new(2,1,boardtest)
        assert_equal(2, player.positionrow)
        assert_equal(1, player.positioncol)
        bird = Bird.new(4,2, boardtest)
        game = Board.new(boardtest, player, bird)
        game.movep('down')
        game.movep('down')
        assert_equal(4, bird.positionrow)
        assert_equal(3, bird.positioncol)
    end
end
