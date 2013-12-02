require_relative '../app/files'

describe Game do
	describe '#win_condition' do
		context 'when the phone is in the front_yard' do
			before do
				@house = double("house")
				front_yard_double = double
				front_yard_double.stub(:inventory) { [:phone] }
				@house.stub(:find_room).with(:front_yard) { front_yard_double }
			end

			it 'should end the game' do
				game = Game.new(@house, double, double)
				game.should_receive(:win_screen)
				game.win_condition
			end
		end

		context 'when the phone is not in the front_yard' do
			before do
				@house = double("house")
				front_yard_double = double
				front_yard_double.stub(:inventory) { [] }
				@house.stub(:find_room).with(:front_yard) { front_yard_double }
			end


			it 'should not end the game' do
				game = Game.new(@house, double, double)
				game.should_not_receive(:win_screen)
				game.win_condition
			end
		end
	end

	describe '#lose_condition' do
    context 'when the player is insane' do
      before do   
      	@player = double     
        @player.stub(:insane?) { true }
      end

      it 'should end the game' do
        game = Game.new(double, @player, double)
        game.should_receive(:lose_screen)
        game.lose_condition 
      end
    end
    
    context 'when the player is not insane' do
    	before do   
      	@player = double     
        @player.stub(:insane?) { false }
      end

      it 'should not end the game' do
        game = Game.new(double, @player, double)
        game.should_not_receive(:end)
        game.lose_condition       
      end
    end
  end

	describe '#create_shovel' do
		before do
			@satchel = double
			@satchel.stub(:contents) {[:frament1, :fragment2, :fragment3]}
			@player = double
			@player.stub(:name).and_return("Some player")
			@house = House.new(@player, @satchel)
			@game = Game.new(@house, @player, @satchel)
		end
		context "when the satchel contains 3 fragments" do
			it 'adds the shovel to the shed inventory' do
				@game.create_shovel
				@house.find_room(:shed).inventory.should include("shovel")
			end
		end
	end
end
