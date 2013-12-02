require_relative './app/files'

puts "Welcome to Grandma's House: The Text Adventure!\r\n
Can you clear up the mystery around Grandma's whereabouts before your sanity reserves are depleted?\r\n
To begin, what's your name?\r\n\r\n"

name = nil
while name.nil?
  name = gets.chomp
end

player = Player.new(name)
satchel = Satchel.new
house = House.new(player, satchel)
game = Game.new(house, player, satchel)

puts "\r\nWelcome, #{player.name}. Grandma does not appear to be home, and her house smells WEIRD.\r\n
Type 'help' if the house starts to adle your brain.\r\n
Press enter to start the game. It's not too late to flee in terror.\r\n\r\n"

start = gets.chomp

game.play
