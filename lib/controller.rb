require 'files'

class TextGame < Sinatra::Base
  set :root, 'lib/app'

	configure :development do
		register Sinatra::Reloader
	end

#Should display introductory text and a field for receiving a name.
	get '/' do
		erb :home
	end

#Should display prompt.
	get '/play' do
		if $game.nil?
			$player = Player.new(params[:name])
			$satchel = Satchel.new
			$house = House.new($player, $satchel)
			$game = Game.new($house, $player, $satchel)
		end

		if $game.game_active
      $game.win_condition
      $player.sanity_check($game)
      $game.unlock_features
      message = $game.prompt_action
      message2 = $game.follow_up_q(params[:command])
      if ($game.hash.has_key?(params[:command]) && params[:command2])
      	$house.switcher(params[:command]).call(params[:command2])
      else
      	#error
	    end
	    last_move_results = $game.describe_last_move
	    desc = $house.get_room_description
	    inv = $house.get_room_inventory
      erb :play, locals: {
      	:desc => desc,
      	:inv => inv,
      	:message => message,
      	:message2 => message2,
      	:last_move_results => last_move_results
      }
    end  
	end

	post '/play' do
	end

end