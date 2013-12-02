require_relative './app/files'

puts "Welcome to Grandma's House: The Text Adventure!\r\n
Can you clear up the mystery around Grandma's whereabouts before your sanity reserves are depleted?\r\n
To begin, what's your name?\r\n\r\n"

name = gets.chomp

puts "\r\nWelcome, #{name}. Grandma does not appear to be home, and her house smells WEIRD.\r\n
Type 'help' if the house starts to adle your brain.\r\n
Press enter to start the game. It's not too late to flee in terror.\r\n\r\n"

start = gets.chomp

player = Player.new(name)
satchel = Satchel.new
house = House.new(player, satchel)
game = Game.new(house, player, satchel)

loop do
  if game.win_condition 
    puts "\r\nLike many an adventurer before you, Grandma's House has driven you mad! GAME OVER."
  elsif game.lose_condition
    puts "\r\nYou take out the phone in the front yard. At last: reception! You call Bob Smith and he puts Grandma on the line. Turns out she's eloped to Florida. Mystery solved. YOU WIN."
  else
    puts "\r\n#{game.prompt_action}\r\n\r\n"
    response = gets.chomp
    if response
      command_array = game.parse(response)
      house.process_commands(command_array[0]).call(command_array[1])
    end
    game.unlock_features
    puts "\r\nTurn summary: "
    puts ">#{house.last_move_message}"
    puts ">#{house.get_room_description}"
    puts ">#{house.get_room_inventory}"
  end
end
