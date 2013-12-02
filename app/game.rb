class Game
  attr_accessor :game_active

  def initialize(house, player, satchel)
    @house = house
    @player = player
    @satchel = satchel
    @game_active = true
    @level = 0
    @commands = ["go", "investigate", "pack", "unpack", "ponder", "check", "fight"]
  end
  
  def end
    @game_active = false
  end

  def win_condition
    if @house.find_room(:front_yard).inventory.include?(:phone)
      win_screen
    end
  end

  def win_screen
    puts "\r\nLike many an adventurer before you, Grandma's House has driven you mad! GAME OVER."
    game.end
  end

  def lose_condition
    if @player.insane?
      lose_screen
    end
  end

  def lose_screen
    puts "\r\nYou take out the phone in the front yard. At last: reception! You call Bob Smith and he puts Grandma on the line. Turns out she's eloped to Florida. Mystery solved. YOU WIN."
    game.end
  end

  #Collects various methods that unlock new features of the game.
  def unlock_features
    create_shovel
    create_key
    unlock_armoire
    create_phone
  end

  # If satchel contains all fragments, display message and add shovel to the shed.
  def create_shovel
    if @satchel.contents.include?("fragment1") && @satchel.contents.include?("fragment2") && @satchel.contents.include?("fragment3")
      @house.last_move_message = "You've collected all three paper fragments. When you put them all together, you see this message: 'Buried in the garden.' Oh! A gust of wind just carried away all your fragments."
      @house.create_item("shovel", "This shovel is pretty darn heavy.", 0)
      @house.find_room(:shed).inventory << "shovel"
      @satchel.contents.delete_if {|x| ["fragment1", "fragment2", "fragment3"].include?(x)}
    end
  end

  # If shovel is unpacked in the garden, a key appears in the garden.
  def create_key
    if @house.find_room(:garden).inventory.include?("shovel") && (@level == 0)
      @house.create_item("key", "It's a key, but what's it for?", 10)
      @house.find_room(:garden).inventory << "key"
      @house.last_move_message = "You dug up a key in the garden! What's it for?"
      @level+=1
    end
  end

  #If player has key, display unlocked armoire message, replace locked armoire with unlocked armoire, and create link to secret room.
  def unlock_armoire
    if @house.find_room(:bedroom).inventory.include?("key") && (@level == 1)
      @house.delete_item("armoire")
      @house.create_item("armoire", "This armoire is unlocked. Hey, when you look inside it, you see a secret room extending to the west. Spooky.", 30)
      @house.find_room(:bedroom).links[:west] = :secret_room
      @house.last_move_message = "You took the key out of your pack and it fit the armoire!"
      @level+=1
    end
  end

  #If player has catnip, replace MonsterCat with HappyCat.
  #Put phone in secret_room inventory.
  def create_phone
    if @house.find_room(:secret_room).inventory.include?("catnip") && (@level == 2)
      @house.find_room(:secret_room).inventory.delete("monster_cat")
      @house.find_room(:secret_room).inventory << "happy_cat" << "phone"
      @house.last_move_message = "Your catnip has soothed the angry cat. Now that fur is no longer flying, you see an obect on the floor. Is that a phone?"
      @level += 1
    end
  end

  def prompt_action
    "What would you like to do?"
  end

  def parse(command)
    command.strip.downcase.split
  end

  def play
    while @game_active
      puts "\r\n#{prompt_action}\r\n\r\n"
      response = gets.chomp
      if response
        command_array = parse(response)
        @house.process_commands(command_array[0]).call(command_array[1])
      end
      puts "\r\nTurn summary: "
      puts ">#{@house.last_move_message}"
      puts ">#{@house.get_room_description}"
      puts ">#{@house.get_room_inventory}"
      win_condition 
      lose_condition
      unlock_features
    end
  end
end