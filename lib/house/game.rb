require_relative '../files'

class Game
  def initialize(house)
    @house = house
    @game_active = true
    @objects = []
  end
  
  def end
    @game_active = false
  end
  
  def register(object)
    @objects << object
  end
  
  def play
    while @game_active
      house.prompt_action
  
      @objects.each do |object|
        object.update(self)
      end  
    end
  end
end