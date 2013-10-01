require_relative '../files'

class Satchel
  attr_accessor :contents
  
  def initialize
    @contents = []
  end
  
  def update(house)
    collect_fragments(house)
    get_key(house)
  end
  
  # If satchel contains all fragments, display message and add shovel to the shed.
  def collect_fragments(house)
    if @contents.include?(:fragment1) && @contents.include?(:fragment2) && @contents.include?(:fragment3)
      puts "You've collected all three paper fragments. When you put them all together, you see this message: 'Buried in the garden.'"
      house.create_item(:shovel, "shovel", "This shovel is pretty darn heavy.", 0)
      house.find_room(:shed).inventory << :shovel
    end
  end
  
  # If shovel is unpacked in the garden, a key appears in the garden.
  def get_key(house)
    if house.find_room(:garden).inventory.contains?(:shovel)
      house.create_item(:key, "key", "There's a key, but what's it for?", 10)
      house.find_room(:garden).inventory << :key
      puts house.find_item(:key).item_description
end 

