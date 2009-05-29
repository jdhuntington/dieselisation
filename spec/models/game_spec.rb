require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Game do

  describe 'named scopes' do
    describe 'open_for_registraion' do
      it 'should return all new games' do
        g0 = Factory.create(:game)
        g1 = Factory.create(:game)
        g2 = Factory.create(:game)
        g2.status = 'active'
        g2.save!
        g3 = Factory.create(:game)
        g3.status = 'finished'
        g3.save!
        games = Game.open_for_registration
        games.length.should == 2
        games.should include(g0)
        games.should include(g1)
      end
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
      g = Factory(:game)
      u0, u1 = Factory(:player), Factory(:player)
      g.add_player u0
      g.add_player u1
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
    
    it 'should be added to the game' do
      Game.any_instance.expects(:add_player)
      g = Factory.create(:game)
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

    it 'should be limited' do
      g = Factory.create(:game)
      g.max_players.should be > 0
    end
  end

  describe '#joinable?' do
    it 'should be joinable if it is new' do
      g = Factory.create(:game, :status => 'new')
      g.should be_joinable
    end

    it 'should not be joinable if it has started' do
      g = Factory.create(:game)
      g.start!
      g.should_not be_joinable
    end

    it 'should not be joinable if it is full' do
      g = Factory.create(:game)
      g.expects(:users).returns(stub_everything(:length => 4))
      g.expects(:max_players).returns(4)
      g.should_not be_joinable
    end
  end

  describe '#add_player' do
    it 'should add the player to the game' do
    end
    
    it 'should start automatically when full' do
      g = Factory.create(:game, :max_players => 2)
      g.expects(:start!)
      g.add_player(Factory.create(:player))
    end

    it 'should not add a player if the game is not joinable' do
      g = Factory.create(:game, :max_players => 2)
      g.expects(:joinable?).returns(false)
      lambda { g.add_player(Factory.create(:player)) }.should raise_error
    end
  end
end
