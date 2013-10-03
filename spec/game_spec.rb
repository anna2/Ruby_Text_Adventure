require_relative '../lib/files'
require 'rspec'

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
				game.should_receive(:end)
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
				game.should_not_receive(:end)
				game.win_condition
			end
		end
	end

	describe '#create_shovel' do
		before do
			satchel = double
		end
		context "when the satchel contains 3 fragments" do
			it 'should add the shovel to the shed inventory' do
			end
		end
	end
end
