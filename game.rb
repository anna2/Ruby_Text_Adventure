class Grandmas_House
  attr_accessor :player
  
  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms=[]
    @items=[]
    @sanity=100
  end
  
  def create_room(tag, description, links, inventory)
    @rooms << Room.new(tag, description, links, inventory)
  end
  
  def start(location) #Customize starting room in Grandma's House; location should be enterred in the form of a room's tag
      @player.location = location
  end  
  
  def find_room(tag) #Search through rooms array to find a room by its tag
      @rooms.detect {|room| room.tag == tag}
  end
  
  def get_room_in_direction(direction) #Given a direction, update players's current location by finding that direction key in the current location's links hash. Print description of new room.
      @player.location = find_room(@player.location).links[direction]
      puts find_room(@player.location).room_description
  end
  
  def move(direction)
      puts "You move " + direction.to_s
      get_room_in_direction(direction)
      if find_room(@player.location).inventory == nil
          puts "No items in this room."
      else
          puts "Items in this room: " + find_room(@player.location).inventory.to_s
      end
  end
  
  def create_item(tag, name, description, sanity_points, room)
      @items << Item.new(tag, name, description, sanity_points, room)
  end
  
  def find_item(tag)
      @items.detect {|item| item.tag == tag}
  end
  
  def investigate(tag)
    puts find_item(tag).item_description
    @sanity = @sanity + find_item(tag).sanity_points
    puts @sanity
  end
    
    class Player
      attr_accessor :name, :location
  
      def initialize(name)
          @name = name
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
      
      def room_description
        "You are in " + @description + "."
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
end

#Create a new game and player.
new_game = Grandmas_House.new("Terry")

#Create a few rooms inside Grandma's House.
new_game.create_room(:kitchen, "an avocado-green kitchen full of fruit flies", {:west => :parlor, :north => :basement}, nil)
new_game.create_room(:parlor, "a parlor stacked to the ceiling with National Geographic magazines", {:east => :kitchen}, nil)
new_game.create_room(:basement, "a basement full of canning jars and 1940s exercise machines. To the south you can see the stairs you just fell down and the light from the kitchen", {:south => :kitchen}, :pickles)

#Create some objects
new_game.create_item(:pickles, "Pickle Jar", "Ugh! That pickle was gross. In fact, you can feel a bout of botulism-induced insanity taking hold.", -10, :basement)   

#Begin interaction with player.
puts "Welcome to Grandma's House: The Text Adventure! Can you clear up the mystery around Grandma's whereabouts before your sanity reserves are depleted? Right now, you're standing in the kitchen where there's a weird smell. What would you like to do?"
new_game.start(:kitchen)

#Sample choices made by player.
new_game.move(:west)
new_game.move(:east)
new_game.move(:north)
new_game.investigate(:pickles)