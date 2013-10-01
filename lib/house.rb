require_relative '../files'

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
    puts "Your satchel has been updated!"
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
