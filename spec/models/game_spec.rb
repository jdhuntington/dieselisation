require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Game do
  describe 'active games' do
    it 'should have a current player' do
      g = Factory(:game, :status => 'active')
      u0, u1 = Factory(:player), Factory(:player)
      g.users << u0
      g.users << u1
      g.current_player = u0
      g.reload
      g.current_player.should == u0
    end
  end

  describe 'game activation' do
    it 'should choose a player to be "active"' do
      g = Factory(:game, :status => 'waiting')
      u0, u1 = Factory(:player), Factory(:player)
      g.users << u0
      g.users << u1
      g.start!
      g.current_player.should_not be_nil
    end
  end

  describe 'owner' do
    it 'should exist' do
      g = Factory.create(:game)
      g.owner.should be_an_instance_of(User)
    end
    
    it 'should respond to owner_name' do
      g = Factory.create(:game)
      g.owner.actual_name = 'JIMBOB'
      g.owner_name.should == 'JIMBOB'
    end
    
    it 'should be seated at the game' do
      g = Factory.create(:game)
      g.users.should include(g.owner)
    end
  end

  describe 'players' do
    it "shouldn't be able to register multiple times"
  end
end
