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

  describe 'name' do
    it 'should be unique' do
      Factory.create(:game, :name => 'foo')
      game = Factory.build(:game, :name => 'foo')
      game.should have(1).errors_on(:name)
    end

    it 'should be present' do
      game = Factory.build(:game, :name => '')
      game.should have(1).errors_on(:name)
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
    it "should be able to register in multiple games" do
      lambda { 
        Factory.create(:game)
        Factory.create(:game)
      }.should_not raise_error
    end
    
    it "shouldn't be able to register multiple times" do
      g = Factory.create(:game)
      lambda { g.users << g.owner }.should raise_error
    end
  end

  describe '#joinable?' do
    it 'should be joinable if it is new' do
      g = Factory.create(:game, :status => 'new')
      g.should be_joinable
    end

    it 'should not be joinable if it has started' do
      g = Factory.create(:game, :status => 'active')
      g.should_not be_joinable
    end
  end
end
