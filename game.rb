class House
  attr_accessor  :rooms, :items, :player, :satchel
    
  def initialize(player, satchel)
    @player = player
    @satchel = satchel
    @rooms=[]
    @items=[]
  end
  
  def create_room(tag, description, links, inventory)
    @rooms << Room.new(tag, description, links, inventory)
  end
  
  def find_room(tag)
    @rooms.detect {|room| room.tag == tag}
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
  
  def create_item(tag, name, description, sanity_points, room)
      @items << Item.new(tag, name, description, sanity_points, room)
  end
  
  def find_item(tag)
      @items.detect {|item| item.tag == tag}
  end
  
  #Add item to Satchel contents. Remove item from room.
  def add_item(item)
    item = item.to_sym
    satchel.contents << item
    puts "Your satchel has been updated!"
    find_room(@player.location).inventory.delete_if {|x| x==item}
  end
  
  #Delete item from the satchel. Add to the room player currently occupies.
  def remove_item(item)
    item = item.to_sym
    satchel.contents.delete_if {|x| x==item}
    find_room(@player.location).inventory << item
    p satchel.contents
    p find_room(@player.location).inventory
  end
  
  
  def prompt_action
    puts "What would you like to do? (\"go\", \"investigate\", \"add\", \"drop\") \n <<"
    command = gets.chomp
    if command == "go"
      puts "In which direction? \n <<" 
      dir = gets.chomp
      player.move(dir, self)
    elsif command == "investigate"
      puts "What object would you like to investigate?"
      obj = gets.chomp
      player.investigate(obj, self)
    elsif command == "add"
      puts "What object would you like to add?"
      item = gets.chomp
      add_item(item)
    elsif command == "drop"
      puts "What object would you like to drop?"
      item = gets.chomp
      remove_item(item)
    else
      puts "That's not allowed in Grandma's house! Try something else."
    end
  end
end



class Player
  attr_accessor :name, :location, :sanity

  def initialize(name)
      @name = name
      @location = :kitchen
      @sanity = 100
  end
  
  #Update players's current location. Print description of new room. Print inventory list.
  def move(direction, house)
      puts "You move #{direction.to_s}."
      house.update_current_room(direction)
      house.get_room_description
      house.get_room_inventory
  end
  
  #Describe items. Print how item affects sanity.
  def investigate(tag, house)
    tag = tag.to_sym
    puts house.find_item(tag).item_description
    @sanity = @sanity + house.find_item(tag).sanity_points
    puts "Your sanity level has changed by #{house.find_item(tag).sanity_points} points."
    puts "Your current sanity level is: #{@sanity}."
  end
end


class Room
  attr_accessor :tag, :description, :links, :inventory

  def initialize(tag, description, links, inventory)
    @tag = tag
    @description = description
    @links = links
    @inventory = inventory
  end
end


class Item
  attr_accessor :tag, :name, :description, :sanity_points, :room
      
    def initialize(tag, name, description, sanity_points, room)
      @tag = tag
      @name = name
      @description = description
      @sanity_points = sanity_points
      @room = room
    end
    
    def item_description
        @description
    end 
end 

class Monster
  attr_accessor :name, :ferocity
  
  def initialize(name, ferocity)
    @name = name
    @ferocity = ferocity
  end
  
end

class Satchel
  attr_accessor :contents
  
  def initialize
    @contents = []
  end
  
end 




#Let the game begin!
puts "Welcome to Grandma's House: The Text Adventure!"
puts "Can you clear up the mystery around Grandma's whereabouts before your sanity reserves are depleted?"
puts "To begin, what's your name?"

#get player name
name = nil
while name.nil?
  print "Player name: "
  name = gets.chomp
end

#create new house and player
player = Player.new(name)
satchel = Satchel.new
house = House.new(player, satchel)


#Create a few rooms inside Grandma's House.
house.create_room(:kitchen, "an avocado-green kitchen full of fruit flies", {:west => :parlor, :north => :basement}, [nil])
house.create_room(:parlor, "a parlor stacked to the ceiling with National Geographic magazines", {:east => :kitchen}, [nil])
house.create_room(:basement, "a basement full of canning jars and 1940s exercise machines. To the south you can see the stairs you just fell down and the light from the kitchen", {:south => :kitchen}, [:pickles])
=begin
house.create_room(:front_yard)
house.create_room(:back_yard)
house.create_room(:bedroom)
house.create_room(:shed)
=end

#Create some objects
house.create_item(:pickles, "Pickle Jar", "Ugh! That pickle was gross. In fact, you can feel a bout of botulism-induced insanity taking hold.", -10, :basement) 
=begin
house.create_item(:shovel, )
house.create_item(:fragment1, )
house.create_item(:fragment2, )
house.create_item(:fragment3, )
house.create_item(:key, )
house.create_item(:armoire, )
house.create_item(:catnip, )
house.create_item(:phone, )
=end


#start game play
puts "Welcome, #{name}. You're in the kitchen where there's a weird smell."
game_over = false
while game_over == false
  house.prompt_action
end

if @sanity <=50
  puts "Your mind is disintegrating at an alrming rate. Sanity level: at or below 50%! Careful now!"
elsif @sanity <=10
  puts "Your sanity level is at or below 10%! Better pause to get a grip on reality!"
elsif @sanity <=0
  puts "Like many an adventurer before you, Grandma's House has driven you mad! GAME OVER."
  game_over = true
end