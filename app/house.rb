require_relative "./files"
class House
  include Headlines
  attr_accessor  :rooms, :items, :player, :satchel, :last_move_message
    
  def initialize(player, satchel)
    @player = player
    @satchel = satchel
    @rooms=[]
    @items = []
    @last_move_message = nil
    create_room(:kitchen, "an avocado-green kitchen full of fruit flies", {:west => :parlor, :north => :basement}, ["pickles", "fragment2"])
    create_room(:parlor, "a parlor stacked to the ceiling with newspapers", {:east => :kitchen, :west => :bedroom, :north => :back_yard, :south => :front_yard}, ["newspapers"])
    create_room(:basement, "a basement full of canning jars and 1940s exercise machines. To the south you can see the stairs you just fell down and the light from the kitchen", {:south => :kitchen})
    create_room(:front_yard, "the front yard on a hill", {:north => :parlor})
    create_room(:back_yard, "the backyard. To the west is a ramshackle shed and to the east is a garden gone wild", {:west => :shed, :east => :garden, :south => :parlor})
    create_room(:bedroom, "the bedroom", {:north => :bathroom, :east => :parlor}, ["armoire", "fragment1"])
    create_room(:bathroom, "the bathroom", {:south => :bedroom})
    create_room(:garden, "an overgrown garden", {:west => :back_yard}, ["catnip"])
    create_room(:shed, "a shed full of junk", {:east => :back_yard}, ["fragment3"] )
    create_room(:secret_room, "a dark, dusty room", {:east => :bedroom}, ["monster_cat"])
    create_item("pickles", "Ugh! That pickle was gross. In fact, you can feel a bout of botulism-induced insanity taking hold.", -10) 
    create_item("fragment1", "You can't really make out what the paper fragment says.", -5)
    create_item("fragment2", "You can't really make out what the paper fragment says.", -5)
    create_item("fragment3", "You can't really make out what the paper fragment says.", -5)
    create_item("armoire", "This armoire looks interesting, but it's locked!", -10)
    create_item("catnip", "Mmm mmm catnip.", -10)
    create_item("phone", "You pick up the phone and browse the recent calls. They're all to a man named Bob Smith. You try to call him, but there's no reception. Maybe there's reception somewhere else?", 0)
    create_item("newspapers", "The headline of the topmost newspaper reads: #{get_onion_headline}.", -5)
    create_item("monster_cat", "This cat is really angry!!! Are you sure you're ready for this battle?", -50)
    create_item("happy_cat", "It's bad karma to mess with a really happy cat. Just leave him alone with his catnip already, #{@player.name}.", -5)
    create_item("phone", "I wonder where there will be good enough reception to use this phone?", 5)
  end
  
  def create_room(tag, description, links, inventory=[])
    @rooms << Room.new(tag, description, links, inventory)
  end
  
  def find_room(tag)
    @rooms.detect {|room| room.tag == tag}
  end

  #Create an item and add it to the master list of all the items in the house.
  def create_item(name, description, sanity_points)
    @items << Item.new(name, description, sanity_points)
  end

  #Search the master list for a particular item.
  def find_item(obj)
    @items.detect {|item| item.name == obj}
  end

  def delete_item(obj)
    @items.delete_if {|item| item.name == obj}
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
    if find_room(@player.location).links.keys.include?(direction.to_sym)
      update_current_room(direction)
      @last_move_message = "You moved #{direction}."
    elsif direction == "help"
      @last_move_message = "Try typing go + a cardinal direction. E.g. go west.\r\n"
    elsif directions.include?(direction) == false
      @last_move_message = "Hmmm...try moving in a cardinal direction."
    else
      @last_move_message = "Unfortunately, only ghosts can walk through walls. You might want to try another way out."
    end
  end
  
  #Move item from the current room to the satchel.
  def add_item(item)
    if find_room(@player.location).inventory.include?(item)
      satchel.contents << item
      @last_move_message = "Your satchel has been updated!"
      find_room(@player.location).inventory.delete_if { |x| x == item }
    elsif item == "help"
      @last_move_message = "Well, you can only pack up objects that are in the room with you...\r\n"
    else
      @last_move_message = "That item is not in the room. Items in this room: #{find_room(@player.location).inventory.join(", ")}."
    end
  end
  
  #Move item from satchel to the room the player currently occupies.
  def remove_item(item)
    if satchel.contents.include?(item)
      satchel.contents.delete_if { |x| x==item} 
      find_room(@player.location).inventory << item
      @last_move_message = "You've succesfully removed the item from your satchel!"
    elsif item == "help"
      @last_move_message = "Try typing unpack + an item you would like to remove from your pack. E.g. unpack pickles. \r\n"
    else
      @last_move_message = "That item was not in your satchel. Your satchel contains: #{satchel.contents.join(", ")}."
    end
  end

  def fight(obj)
    if obj == "cat"
      investigate(obj)
    elsif obj == "help"
      @last_move_message = "If I were you, I would only fight when provoked."
    else
      @last_move_message = "Hey now, take a few deep breaths.\r\nOnly fight with things that deserve it."
      @player.sanity -= 5
    end
  end

  #Describe item. Print how item affects sanity.
  def investigate(obj)
    if find_room(@player.location).inventory.include?(obj) || satchel.contents.include?(obj)
      @player.sanity += find_item(obj).sanity_points
      @last_move_message = "#{find_item(obj).description} \r\nYour sanity level has changed by #{find_item(obj).sanity_points} points."
    elsif obj == "help"
      @last_move_message = "Try typing investigate + an object in the room or in your pack. E.g. investigate armoire.\r\n"
    else
      @last_move_message = "That item does not appear to be in the room. #{get_room_inventory}"
    end
  end

  def check(arg)
    case arg
    when "satchel"
      satchel_contents
    when "sanity"
      @last_move_message = "Your current sanity level is #{@player.sanity}"
    when "help"
      @last_move_message = "You might try checking your satchel or your sanity."
    end
  end

  def satchel_contents
    if @satchel.contents.size > 0
      @last_move_message = "Your satchel contains: #{@satchel.contents.join(", ")}."
    else
      @last_move_message = "Your satchel is empty."
    end
  end

  def help(_)
    @last_move_message = "The available commands are: go, investigate, pack, unpack, check, fight, help. For help with a specific command, type a command + help. E.g. go help"
  end

  def error(_)
    @last_move_message = "That's not allowed in Grandma's House. Try something else."
  end

  def process_commands(command)
    case command
    when "go"
      method(:move)
    when "investigate"
      method(:investigate)
    when "pack"
      method(:add_item)
    when "unpack"
      method(:remove_item)
    when "check"
      method(:check)
    when "fight"
      method(:fight)
    when "help"
      method(:help)
    else
      method(:error)
    end
  end
end


