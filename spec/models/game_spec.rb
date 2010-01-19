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

    it 'should persist a new game state' do
      g = Factory(:game)
      3.times { g.add_player Factory(:player) }
      g.expects(:persist!)
      g.start!
    end
  end

  describe '#game_instance' do
    it 'should load the game state from game_state' do
      g = Factory(:game)
      g.expects(:game_state).at_least_once.returns(stub_everything('gamestate', :game_instance => :something))
      g.game_instance
      assert_equal :something, g.game_instance
    end
    
    it 'should cache the value' do
      g = Factory(:game)
      g.game_instance = :something
      g.expects(:game_state).never
      assert_equal :something, g.game_instance
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
      Dieselisation::GameInstance.stubs(:new).returns(:dummy)
      g = Factory.create(:game)
      g.stubs(:persist!)
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

  describe '#current_player' do
    it 'should return the player associated with the uniq_id of the game instaces current player' do
      g = Factory.create(:game)
      g.stubs(:status).returns('active')
      instance = stub 'instance'
      g.stubs(:game_instance).returns(stub_everything('instance', :current_player_identifier => g.owner.id))
      g.current_player.should == g.owner
    end

    it 'should raise an exception if called when game is not started' do
      g = Factory.create(:game)
      instance = stub 'instance'
      g.stubs(:game_instance).returns(stub_everything('instance', :current_player_identifier => g.owner.id))
      lambda {
        g.current_player
      }.should raise_error
    end

  end

  describe '#persist' do
    it 'should save the current player on persist' do
      g = Factory(:game)
      u0, u1 = Factory(:player), Factory(:player)
      g.add_player u0
      g.add_player u1
      g.start!
      g.game_state.active_player.should == g.current_player
    end
    
    it 'should add the state to the list of game instance histories' do
      g = Factory(:game)
      u0, u1 = Factory(:player), Factory(:player)
      g.add_player u0
      g.add_player u1
      g.start!
      original_game_state = g.game_state
      g.persist!
      new_game_state = g.game_state
      new_game_state.previous.should == original_game_state
    end
  end

  describe '#requires_confirmation?' do
    it 'should return the current game state\'s response' do
      g = Factory(:game)
      g.stubs(:game_state).returns(stub_everything(:requires_confirmation? => :thevalue))
      g.requires_confirmation?.should == :thevalue
    end
  end

  describe '#act' do
    it 'should raise an exception if the game requires confirmation' do
      game = Factory(:game)
      game_state = Factory(:game_state)
      game.game_state = game_state

      game_state.stubs(:requires_confirmation?).returns(true)
      illegal_action = lambda {
        game.act({ })
      }
      illegal_action.should raise_error(GameStateNeedsConfirmation)
    end
  end
  
end
