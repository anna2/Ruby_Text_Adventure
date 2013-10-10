require_relative '../files'

class House
  attr_accessor  :rooms, :items, :player, :satchel
    
  def initialize(player, satchel)
    @player = player
    @satchel = satchel
    @rooms=[]
    @items = []
    create_room(:kitchen, "an avocado-green kitchen full of fruit flies", {:west => :parlor, :north => :basement}, [:pickles, :fragment2])
    create_room(:parlor, "a parlor stacked to the ceiling with National Geographic magazines", {:east => :kitchen, :west => :bedroom, :north => :back_yard}, [nil])
    create_room(:basement, "a basement full of canning jars and 1940s exercise machines. To the south you can see the stairs you just fell down and the light from the kitchen", {:south => :kitchen}, [:pickles])
    create_room(:front_yard, "on a hill in the front yard looking down on Grandma's house", {:north => :parlor}, [])
    create_room(:back_yard, "the backyard. To the west is a ramshackle shed and to the east is a garden gone wild", {:west => :shed, :east => :garden, :south =>  :parlor}, [])
    create_room(:bedroom, "the bedroom", {:north => :bathroom, :east => :parlor}, [:armoire, :fragment1])
    create_room(:bathroom, "the bathroom", {:south => :bedroom}, [])
    create_room(:garden, "an overgrown garden", {:west => :back_yard}, [:catnip])
    create_room(:shed, "a shed full of junk", {:east => :back_yard}, [:fragment3] )
    create_item(:pickles, "Pickle Jar", "Ugh! That pickle was gross. In fact, you can feel a bout of botulism-induced insanity taking hold.", -10) 
    create_item(:fragment1, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
    create_item(:fragment2, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
    create_item(:fragment3, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
    create_item(:armoire, "armoire", "This armoire looks interesting, but it's locked!", -10)
    create_item(:catnip, "catnip", "Mmm mmm catnip.", -10)
    create_item(:phone, "phone", "You pick up the phone and browse the recent calls. They're all to a man named Bob Smith. You try to call him, but there's no reception. Maybe there's reception somewhere else?", 0)
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
