require_relative '../files'

class Game
  def initialize(house, player, satchel)
    @house = house
    @player = player
    @satchel = satchel
    @game_active = true
  end
  
  def end
    @game_active = false
  end

  def win_condition
    if @house.find_room(:front_yard).inventory.include?(:phone)
      puts "You take out the phone in the front yard. At last: reception! You call Bob Smith and he puts Grandma on the line. Turns out she's eloped to Florida. YOU WIN."
      self.end
    end
  end

  #Collects various methods that unlock new features of the game.
  def unlock_features
    create_shovel
    create_key
  end

  # If satchel contains all fragments, display message and add shovel to the shed.
  def create_shovel
    if @satchel.contents.include?(:fragment1) && @satchel.contents.include?(:fragment2) && @satchel.contents.include?(:fragment3)
      puts "You've collected all three paper fragments. When you put them all together, you see this message: 'Buried in the garden.'"
      puts "Oh! A gust of wind just carried away all your fragments."
      @satchel.contents.delete_if {|x| x == (:fragment1 || :fragment2 || :fragment3)}
      house.find_room(:shed).inventory << Item.new(:shovel, "shovel", "This shovel is pretty darn heavy.", 0)
    end
  end

  # If shovel is unpacked in the garden, a key appears in the garden.
  def create_key
    if @house.find_room(:garden).inventory.include?(:shovel)
      @house.find_room(:garden).inventory << Item.new(:key, "key", "There's a key, but what's it for?", 10)
      puts house.find_item(:key).item_description #FIX ME!!!!
    end
  end
  
  def play
    while @game_active
      prompt_action
      win_condition
      @player.sanity_check(self)
      unlock_features
    end  
  end

  def prompt_action
    puts "What would you like to do? (\"go\", \"investigate\", \"pack\", \"unpack\") \n <<"
    command = gets.chomp
    if command == "go"
      puts "In which direction? \n <<" 
      dir = gets.chomp
      @player.move(dir, @house)
    elsif command == "investigate"
      puts "What object would you like to investigate?"
      obj = gets.chomp
      @player.investigate(obj, @house)
    elsif command == "pack"
      puts "What object would you like to pack?"
      item = gets.chomp
      @house.add_item(item)
    elsif command == "unpack"
      puts "What object would you like to unpack?"
      item = gets.chomp
      @house.remove_item(item)
    else
      puts "That's not allowed in Grandma's house! Try something else."
    end
  end

end