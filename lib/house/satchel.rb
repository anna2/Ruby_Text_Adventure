require_relative '../files'

class Satchel
  attr_accessor :contents
  
  def initialize
    @contents = []
  end
  
  def update(game)
    collect_fragments(game)
    get_key(game)
  end
  
  # If satchel contains all fragments, display message and add shovel to the shed.
  def collect_fragments(game)
    if @contents.include?(:fragment1) && @contents.include?(:fragment2) && @contents.include?(:fragment3)
      puts "You've collected all three paper fragments. When you put them all together, you see this message: 'Buried in the garden.'"
      puts "Oh! A gust of wind just carried away all your fragments."
      @contents.delete_if {|x| x == (:fragment1 || :fragment2 || :fragment3)}
      game.create_item(:shovel, "shovel", "This shovel is pretty darn heavy.", 0)
      game.find_room(:shed).inventory << :shovel
    end
  end
  
  # If shovel is unpacked in the garden, a key appears in the garden.
  def get_key(game)
    if game.find_room(:garden).inventory.include?(:shovel)
      game.create_item(:key, "key", "There's a key, but what's it for?", 10)
      game.find_room(:garden).inventory << :key
      puts game.find_item(:key).item_description
    end
  end
end 

