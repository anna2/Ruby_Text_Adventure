require_relative '../files'

class Monster
  attr_accessor :name, :ferocity
  
  def initialize(name, ferocity)
    @name = name
    @ferocity = ferocity
  end
  
  def attack(player, house)
    puts "There is an angry cat in this room!" 
    if house.find_room(@player.location).inventory.include?(:catnip)
      puts "The cat has been soothed by catnip. You are now able to access the objects in this room."
    else
      puts "Really angry. You better leave before you get scratched to death. Your sanity level is already dropping."
      player.sanity = player.sanity - 20
      puts "Your current sanity level is: #{player.sanity}."
    end
  end
end