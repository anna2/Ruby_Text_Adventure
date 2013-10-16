require_relative '../files'


class Player
  attr_accessor :name, :location, :sanity

  def initialize(name)
      @name = name
      @location = :kitchen
      @sanity = 100
  end
  
  def sanity_check(game)
    if is_insane?
      puts "Like many an adventurer before you, Grandma's House has driven you mad! GAME OVER."
        game.end
    end
  end
  
  def is_insane?
    if @sanity <=0
      true
    end
  end
end