require_relative '../files'


class Player
  attr_accessor :name, :location, :sanity

  def initialize(name)
      @name = name
      @location = :kitchen
      @sanity = 100
  end
  
  def update(game)
    if is_insane?
      puts "Like many an adventurer before you, Grandma's House has driven you mad! GAME OVER."
      game.end
    end
  end
  
  #Update players's current location. Print description of new room. Print inventory list.
  def move(direction, house)
    if house.find_room(@location).links.include?(direction.to_sym)
      puts "You move #{direction.to_s}."
      house.update_current_room(direction)
      house.get_room_description
      house.get_room_inventory
    else
      puts "Unfortunately, only ghosts can walk through walls. You might want to try another way out."
    end
  end
  
  #Describe items. Print how item affects sanity.
  def investigate(tag, house)
    tag = tag.to_sym
    puts house.find_item(tag).item_description
    @sanity = @sanity + house.find_item(tag).sanity_points
    puts "Your sanity level has changed by #{house.find_item(tag).sanity_points} points."
    puts "Your current sanity level is: #{@sanity}."
  end
  
  def is_insane?
    if @sanity <=0
      true
    end
  end
end