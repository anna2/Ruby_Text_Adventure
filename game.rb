require_relative 'lib/files.rb'

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
house.create_room(:kitchen, "an avocado-green kitchen full of fruit flies", {:west => :parlor, :north => :basement}, [:fragment2])
house.create_room(:parlor, "a parlor stacked to the ceiling with National Geographic magazines", {:east => :kitchen}, [nil])
house.create_room(:basement, "a basement full of canning jars and 1940s exercise machines. To the south you can see the stairs you just fell down and the light from the kitchen", {:south => :kitchen}, [:pickles])
house.create_room(:front_yard, "on a hill in the front yard looking down on Grandma's house", {:north => :parlor}, [])
house.create_room(:back_yard, "the backyard. To the west is a ramshackle shed and to the east is a garden gone wild", {:west => :shed, :east => :garden, :south =>  :parlor}, [])
house.create_room(:bedroom, "the bedroom", {:north => :bathroom, :east => :parlor}, [:armoire, :fragment1])
house.create_room(:bathroom, "the bathroom", {:south => :bedroom}, [])
house.create_room(:garden, "an overgrown garden", {:west => :back_yard}, [:catnip])
house.create_room(:shed, "a shed full of junk", {:east => :back_yard}, [:shovel, :fragment3] )

#Create some objects
house.create_item(:pickles, "Pickle Jar", "Ugh! That pickle was gross. In fact, you can feel a bout of botulism-induced insanity taking hold.", -10) 
house.create_item(:shovel, "shovel", "This shovel is pretty darn heavy.", 0)
house.create_item(:fragment1, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
house.create_item(:fragment2, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
house.create_item(:fragment3, "a fragment of a note", "You can't really make out what the paper fragment says.", 0)
house.create_item(:key, "key", "It's a key, but what's it for?", 0)
house.create_item(:armoire, "armoire", "This armoire looks interesting, but it's locked!", -10)
house.create_item(:catnip, "catnip", "Mmm mmm catnip.", -10)
house.create_item(:phone, "phone", "You pick up the phone and browse the recent calls. They're all to a man named Bob Smith. You try to call him, but there's no reception. Maybe there's reception somewhere else?", 0)


#start game play
puts "Welcome, #{name}. You're in the kitchen where there's a weird smell."
house.prompt_action

game_active = true
while game_active == true
  if player.is_insane?
    puts "Like many an adventurer before you, Grandma's House has driven you mad! GAME OVER."
    game_active = false
  elsif house.find_room(:front_yard).inventory.include?(:phone)
    puts "You take out the phone in the front yard. At last: reception! You call Bob Smith and he puts Grandma on the line. Turns out she's eloped to Florida. YOU WIN."
    game_active = false
  else
    house.prompt_action
  end
end

