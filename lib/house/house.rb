require_relative '../files'

class House
  attr_accessor  :rooms, :items, :player, :satchel
    
  def initialize(player, satchel)
    @player = player
    @satchel = satchel
    @rooms=[]
    @items = []
  end
  
  def create_room(tag, description, links, inventory)
    @rooms << Room.new(tag, description, links, inventory)
  end
  
  def find_room(tag)
    @rooms.detect {|room| room.tag == tag}
  end

  #Create an item and add a reference to it to the master list of all the items in the house.
  def create_item(symbol_name, name, description, sanity_points)
    symbol_name = Item.new(name, description, sanity_points)
    @items << symbol_name

  #Search the master list for a particular item.
  def find_item(obj)
    obj = obj.to_sym
    @items.detect {|item| item = obj}
  end
  
  #takes current player location and finds the next room in the specified direction
  def update_current_room(direction)
    direction = direction.to_sym
    @player.location = find_room(@player.location).links[direction]
  end
  
  def get_room_description
    puts "You're in #{find_room(@player.location).description}."
  end
  
  def get_room_inventory
    if find_room(@player.location).inventory == nil
      puts "No items in this room."
    else
      list = find_room(@player.location).inventory
      list = list.join(", ")
      puts "Items in this room: #{list}."
    end
  end
  
  #Move item from the current room to the satchel.
  def add_item(item)
    item = item.to_sym    
    if find_room(@player.location).inventory.include?(item)
      satchel.contents << item
      puts "Your satchel has been updated!"
      find_room(@player.location).inventory.delete_if {|x| x==item}
    else
      puts "That item is not in the room."
      puts "Items in this room: #{find_room(@player.location).inventory.join(", ")}."
    end
  end
  
  #Move item from satchel to the room the player currently occupies.
  def remove_item(item)
    item = item.to_sym
    if satchel.contents.include?(item)
      satchel.contents.delete_if {|x| x==item}
      find_room(@player.location).inventory << item
      puts "Your satchel has been updated!"
    else
      puts "That's not in your satchel. Your satchel contains: #{satchel.contents.join(", ")}."
    end
  end
end
end
