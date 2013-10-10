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

# Should accept the player name, greet them, initialize player and other objects.
	post '/' do
		"Welcome, (params[:name]). You're in the kitchen where there's a weird smell."
		player = Player.new(params[:name])
		satchel = Satchel.new
		house = House.new(player, satchel)
		game = Game.new(house, player, satchel)
		redirect '/play'
	end

#Should display prompt.
	get '/play' do
		message = game.prompt_action
		erb :play, locals: {:message => message}
	end

#Should process reader answer and redirect to correct message.
	post '/play' do

	end


end