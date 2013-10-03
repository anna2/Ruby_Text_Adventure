require_relative '../lib/files'
require 'rspec'

describe Player do
  before do
    @player = Player.new("Some Player")
  end
  
  describe '#sanity_check' do
    context 'when the player is insane' do
      before do        
        item = Item.new("name", "description", -100)
        house = double
        house.stub(:find_item) { item }
        @player.investigate('some tag', house)
      end

      it 'should end the game' do
        game = double
        game.should_receive(:end)
        
        @player.sanity_check(game) 
      end
    end
    
    context 'when the player is not insane' do
      it 'should not end the game' do
        game = double
        game.should_not_receive(:end)
        
        @player.sanity_check(game)         
      end
    end
  end
end