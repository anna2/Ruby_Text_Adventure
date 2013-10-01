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
  
  def find_room(room)
    @house.find_room(room)
  end
  
  def create_item(tag, name, description, sanity_points)
      @house.create_item(tag, name, description, sanity_points)
  end
  
  def find_item(tag)
      @house.find_item(tag)
  end
  
  def play
    while @game_active
      @house.prompt_action
  
      @objects.each do |object|
        object.update(self)
      end  
    end
  end
end