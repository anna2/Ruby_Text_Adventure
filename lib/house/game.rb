require_relative '../files'

class Game
  attr_accessor :game_active, :hash

  def initialize(house, player, satchel)
    @house = house
    @player = player
    @satchel = satchel
    @game_active = true
    @hash = {
      "go" => "In which direction?", 
      "investigate" => "What object would you like to investigate?",
      "pack" => "What object would you like to pack?",
      "unpack" => "What object would you like to unpack?",
      "check" => "Check what? Your satchel perhaps?"
    }
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
      puts @house.find_item(:key).item_description #FIX ME!!!!
    end
  end

  #If player has key, armoire can be unlocked.
  #In practice, replace the locked armoire item with an unlocked armoire item.
  def unlock_armoire
    if @house.find_room(:bedroom).inventory.include?(:key)
      #create unlocked armoire
      create_item(:armoire_unlocked, "armoire", "This armoire is unlocked. Hey, when you look inside it, you see a secret room extending to the west. Spooky.", 30)
      @house.find_room(:bedroom).inventory << :armoire_unlocked
      #delete locked armoire reference in bedroom array
      @house.find_room(:bedroom).inventory.delete(:armoire_locked)
      @last_move_message = "You took the key out of your pack and it fit the armoire!"
      #create secret_room visible through unlocked armoire
      create_room(:secret_room, "a dark, dusty room", {:east => :bedroom})
      @house.find_room(:bedroom).links[:west => :secret_room]
      #populate secret_room with an angry cat!
      create_item(:monster_cat, "This cat is really angry!!! Are you sure you're ready for this battle?", -50)
      @house.find_room(:secret_room).inventory << :monster_cat
    end
  end

  #Player needs catnip to defeat cat.
  #If player defeats cat, put phone in secret_room inventory.
  def create_phone
    if @house.find_room(:inventory).include?(:catnip)
      #delete angry cat & create happy cat
      @house.find_room(:secret_room).inventory.delete(:monster_cat)
      create_item(:happy_cat, "happy cat", "It's bad karma to mess with a really happy cat. Just leave him alone with his catnip already, #{@player.name}.", -5)
      @house.find_room(:secret_room).inventory << :happy_cat
      #create phone
      create_item(:phone, "phone", "I wonder where there will be good enough reception to use this phone?", 0)
      #TO DO: restore sanity
      @last_move_message = "Your catnip has soothed the angry cat. Now that fur is no longer flying, you see an obect on the floor. Is that a phone?"
    end
  end

  def prompt_action
    "What would you like to do? (\"go\", \"investigate\", \"pack\", \"unpack\", \"check\", \"ponder\", \"fight\")"
  end

  def follow_up_q(command)
    if @hash.has_key?(command)
      message2 = @hash[command]
    else
      message2 = "That's not allowed in Grandma's house! Try something else."
    end
    message2
  end

  def describe_last_move
    "#{@house.last_move_message}"
  end

end