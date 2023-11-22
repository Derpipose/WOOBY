
require 'glimmer-dsl-libui'

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
    size = 25
    color = {r: 210, g: 20, b:210}
    positionx = 0
    positiony = 0

    def initialize (x, y)
        @positionx = x
        @positiony = y
    end

    def move(way)
        if way == 'up'
            @positiony += 1
        elsif way == 'left'
            @positionx -= 1
        elsif way == 'right'
            @positionx += 1
        else
            @postiony -= 1
        end
    end

end

class Board 
    Chunks = [[]]
    def initialize(layout)
        @Chunks = layout
    end
end

# window('Derp Test').show
# end

player=Player.new(1,3)
puts "#{player.positionx}"
puts player.positiony
player.move('up')
puts "#{player.positionx}"
puts player.positiony