require 'glimmer-dsl-libui'

class ChaseTheBird
  include Glimmer

  BLOCK_SIZE = 75
  PLAYER_SIZE = 75
  BEVEL_CONSTANT = 20
  COLOR_DARK_GREY = { r: 50, g: 50, b: 50 }
  COLOR_LIGHT_GREY = { r: 250, g: 250, b: 250 }
  PLAYER_COLOR = { r: 100, g: 150, b: 170 }
  BIRD_COLOR = { r: 170, g: 100, b: 170 }

  def initialize
  end

  def launch(board)
    @game = board
    @game.printBoard
    create_gui(@game)
    @main_window.show
  end

  def create_gui(board)
    @main_window = window('Look to your Terminal') {
      content_size board.layout[0].size * BLOCK_SIZE, board.layout[0].size * BLOCK_SIZE
      resizable false

      vertical_box {
        padded false
        board.layout.each_with_index do |row, x|
          horizontal_box {
            padded false

            row.each_with_index do |element, y|

                color = element == 'x' ? COLOR_DARK_GREY : COLOR_LIGHT_GREY
                block(row: x, column: y, block_size: BLOCK_SIZE, color: color)

            end
          }
        end
      }
    }
  end

  def updateboard(board)
    @main_window =
    vertical_box {
      padded false
      board.layout.each_with_index do |row, x|
        horizontal_box {
          row.each_with_index do |element, y|
            if
              color = element == 'x' ? COLOR_DARK_GREY : COLOR_LIGHT_GREY
              block(row: x, column: y, block_size: BLOCK_SIZE, color: color)
            end
            if [x , y] == [board.player.positionrow, board.player.positioncol]
              block(row: x, column: y, block_size: PLAYER_SIZE, color: PLAYER_COLOR)
            elsif [x, y] == [board.bird.positionrow, board.bird.positioncol]
              block(row: x, column: y, block_size: PLAYER_SIZE, color: BIRD_COLOR)
            end
          end
        }
      end
    }
  end

  def block(row:, column:, block_size:, color:)
    bevel_pixel_size = 0.16 * block_size.to_f
    area {
      square(0, 0, block_size) {
        fill color
      }

      on_key_down do |key_event|
        system("clear")
        case key_event
        in ext_key: :down
          @game.movep('down')
          # puts 'moving down'
        in ext_key: :up
          @game.movep('up')
          # puts 'moving up'
        in ext_key: :left
          @game.movep('left')
          # puts 'moving left'
        in ext_key: :right
          @game.movep('right')
          # puts 'moving right'
        else
          # Do Nothing
        end
        updateboard(@game)
        # puts 'updated game'
        @game.printBoard
        # puts @game.player.positioncol
        # puts @game.player.positionrow
      end
    }
  end



end
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
      if@board[checkrow+1][checkcol] == '0'
        while @board[checkrow][checkcol] == '0'  do
            if @board[checkrow -1][checkcol-1] == '0' || @board[checkrow-1][checkcol +1] == '0'

                return  true
            end
            checkrow -=1
        end
      end
      return false
  end

  def checkDown
      checkrow = @positionrow
      checkcol = @positioncol
      if@board[checkrow+1][checkcol] == '0'
        while @board[checkrow][checkcol] == '0' do
            if @board[checkrow +1][checkcol-1] == '0' || @board[checkrow+1][checkcol +1] == '0'
                movedown = true
                movecomplete = true
            end
            checkrow +=1
        end
      end
      return false
  end

  def checkLeft
      checkrow = @positionrow
      checkcol = @positioncol
      if@board[checkrow][checkcol-1] == '0'
        while @board[checkrow][checkcol] == '0' do
            if @board[checkrow-1][checkcol -1] == '0' || @board[checkrow+1][checkcol -1] == '0'

                return true
            end
            checkcol -=1
        end
      end
      return false
  end

  def checkRight
      checkrow = @positionrow
      checkcol = @positioncol
      if@board[checkrow][checkcol+1] == '0'
        while @board[checkrow][checkcol] == '0' do
            if @board[checkrow-1][checkcol +1] == '0' || @board[checkrow+1][checkcol +1] == '0'
                return true
            end
            checkcol +=1
        end
      end
      return false
  end


  ##TODO COMPLETE BIRD RESPONSE
  def movecheck(row, col)
      checkCaught(row, col)
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
              if @board[@positionrow - 1][@positioncol] == '0'
                  @positionrow -= 1;
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


  def checkCaught(row,col)
      if col ==positioncol && row == positionrow
        @caught = true
        puts "You caught the bird!"
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
  attr_reader :layout, :player, :bird

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


  def printBoard
      @layout.each_with_index do |row, x|
          printrow = ''
          row.each_with_index do |cell, y|
              if x == @player.positionrow && y == @player.positioncol
                printrow += 'B'
              elsif x == @bird.positionrow && y == @bird.positioncol
                printrow += 'V'
              elsif @layout[x][y] == '0'
                printrow += ' '
              else
                printrow += @layout[x][y]
              end
          end
          puts printrow
      end
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
player = Player.new(6,1,board)
bird = Bird.new(6,7, board)
level1 = Board.new(board, player, bird)

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
player2 = Player.new(2,1,boardtest)
bird2 = Bird.new(4,2, boardtest)
level2 = Board.new(boardtest, player2, bird2)

# ChaseTheBird.new.launch(level1)
ChaseTheBird.new.launch(level2)
