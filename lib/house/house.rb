require_relative '../files'

class House

  attr_accessor  :rooms, :items, :player, :satchel, :last_move_message
    
  def initialize(player, satchel)
    @player = player
    @satchel = satchel
    @rooms=[]
    @items = []
    @last_move_message = nil
    create_room(:kitchen, "an avocado-green kitchen full of fruit flies", {:west => :parlor, :north => :basement}, [:pickles, :fragment2])
    create_room(:parlor, "a parlor stacked to the ceiling with newspapers", {:east => :kitchen, :west => :bedroom, :north => :back_yard}, [:newspapers])
    create_room(:basement, "a basement full of canning jars and 1940s exercise machines. To the south you can see the stairs you just fell down and the light from the kitchen", {:south => :kitchen}, [])
    create_room(:front_yard, "on a hill in the front yard looking down on Grandma's house", {:north => :parlor}, [])
    create_room(:back_yard, "the backyard. To the west is a ramshackle shed and to the east is a garden gone wild", {:west => :shed, :east => :garden, :south =>  :parlor}, [])
    create_room(:bedroom, "the bedroom", {:north => :bathroom, :east => :parlor}, [:armoire_locked, :fragment1])
    create_room(:bathroom, "the bathroom", {:south => :bedroom}, [])
    create_room(:garden, "an overgrown garden", {:west => :back_yard}, [:catnip])
    create_room(:shed, "a shed full of junk", {:east => :back_yard}, [:fragment3] )
    create_item(:pickles, "Pickle Jar", "Ugh! That pickle was gross. In fact, you can feel a bout of botulism-induced insanity taking hold.", -10) 
    create_item(:fragment1, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
    create_item(:fragment2, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
    create_item(:fragment3, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
    create_item(:armoire_locked, "armoire", "This armoire looks interesting, but it's locked!", -10)
    create_item(:catnip, "catnip", "Mmm mmm catnip.", -10)
    create_item(:phone, "phone", "You pick up the phone and browse the recent calls. They're all to a man named Bob Smith. You try to call him, but there's no reception. Maybe there's reception somewhere else?", 0)
    create_item(:newspapers, "newspapers", "The headline of the topmost newspaper reads: #{Headlines.get_onion_headline}.", -5)
  end
  
  def create_room(tag, description, links, inventory)
    @rooms << Room.new(tag, description, links, inventory)
  end
  
  def find_room(tag)
    @rooms.detect {|room| room.tag == tag}
  end

  #Create an item and add it to the master list of all the items in the house.
  def create_item(symbol_name, name, description, sanity_points)
    @items << Item.new(symbol_name, name, description, sanity_points)
  end

  #Search the master list for a particular item.
  def find_item(obj)
    @items.detect {|item| item.symbol_name == obj}
  end
  
  #takes current player location and finds the next room in the specified direction
  def update_current_room(direction)
    direction = direction.to_sym
    @player.location = find_room(@player.location).links[direction]
  end
  
  def get_room_description
    "You're in #{find_room(@player.location).description}."
  end
  
  def get_room_inventory
    if find_room(@player.location).inventory == []
      "No items in this room."
    else
      list = find_room(@player.location).inventory
      list = list.join(", ")
      "Items in this room: #{list}."
    end
  end

  #Update players's current location. Print description of new room. Print inventory list.
  def move(direction)
    directions = ["north", "south", "east", "west"]
    if find_room(@player.location).links.include?(direction.to_sym)
      update_current_room(direction)
      @last_move_message = "You moved #{direction}."
    elsif directions.include?(direction) == false
      @last_move_message = "Hmmm...try moving in a cardinal direction."
    else
      @last_move_message = "Unfortunately, only ghosts can walk through walls. You might want to try another way out."
    end
  end
  
  #Move item from the current room to the satchel.
  def add_item(item)
    item = item.to_sym    
    if find_room(@player.location).inventory.include?(item)
      satchel.contents << item
      @last_move_message = "Your satchel has been updated!"
      find_room(@player.location).inventory.delete_if {|x| x==item}
    else
      @last_move_message = "That item is not in the room. Items in this room: #{find_room(@player.location).inventory.join(", ")}."
    end
  end
  
  #Move item from satchel to the room the player currently occupies.
  def remove_item(item)
    item = item.to_sym
    if satchel.contents.include?(item)
      satchel.contents.delete_if {|x| x==item}
      find_room(@player.location).inventory << item
      @last_move_message = "You've succesfully removed the item from your satchel!"
    else
      @last_move_message = "That item was not in your satchel. Your satchel contains: #{satchel.contents.join(", ")}."
    end
  end

  #Describe item. Print how item affects sanity.
  def investigate(obj)
    if find_room(@player.location).inventory.include?(obj.to_sym) || satchel.contents.include?(obj.to_sym)
      # if obj.to_sym == :newspapers
      #   @last_move_message = "The topmost newspaper reads: #{get_onion_headline}."
      # end
      @player.sanity += find_item(obj.to_sym).sanity_points
      @last_move_message = "#{find_item(obj.to_sym).description} Your sanity level has changed by #{find_item(obj.to_sym).sanity_points} points. Your current sanity level is: #{@player.sanity}."
    else
      @last_move_message = "That item does not appear to be in the room. #{get_room_inventory}"
    end
  end

  def satchel_contents(satchel)
    if @satchel.contents.size > 0
      @last_move_message = "Your satchel contains: #{@satchel.contents.join(", ")}."
    else
      @last_move_message = "Your satchel is empty."
    end
  end

  def switcher(command1)
    if command1 == "go"
      method(:move)
    elsif command1 == "investigate"
      method(:investigate)
    elsif command1 == "pack"
      method(:add_item)
    elsif command1 == "unpack"
      method(:remove_item)
    elsif command1 == "check"
      method(:satchel_contents)
    end
  end
end


