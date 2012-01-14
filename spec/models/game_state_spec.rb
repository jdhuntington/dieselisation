require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class GameStateSpecImpl
  attr_reader :actions
  
  def act(options)
    @actions ||= []
    @actions << options
  end
end

describe GameState do
  describe 'statefulness' do
    before do
      @game = Factory.create(:game, :implementation => 'GameStateSpecImpl')
      @player = Factory.create(:player)
    end

    describe '#act' do
      before do
        @game_state = GameState.create!({ :game => @game })
      end
      
      it 'should apply the action to the game instance' do
        @game_state.game_instance.expects(:act).with({ :foo => :bar })
        @game_state.act({ :foo => :bar })
      end
      
      it 'should create a new game state for game' do
        @game_state.act({ :foo => :bar })
        @game.reload
        @game.game_state.previous.should == @game_state
      end
    end

    describe '#game_instance' do
      it 'should return a new instance of game\'s implementation if no previous' do
        @game_state = GameState.create!({ :game => @game })
        @game_state.game_instance.should be_a_kind_of(GameStateSpecImpl)
      end

      it 'should return an instance with all previous actions applied' do
        g0 = GameState.create!({ :game => @game })
        a1 = { :foo => 'bar' }
        a2 = { :doodle => :dawdle, 1 => 4 }
        g1 = GameState.create!({ :game => @game, :previous => g1, :action => a1.to_json })
        g2 = GameState.create!({ :game => @game, :previous => g2, :action => a2.to_json })
        g2.game_instance.actions == [a1, a2]
      end
    end
  end

  describe 'history' do
    it 'should have a previous node' do
      gs_original = GameState.create!
      gs_current = GameState.create!(:previous => gs_original)
      GameState.find(gs_current).previous.should == gs_original
    end
  end

  describe 'confirmation' do
    it 'should not require confirmation if the last two game states have the same active player' do
      player = Factory.create(:player)
      gs_original = GameState.create!(:active_player => player)
      gs_current = GameState.create!(:previous => gs_original, :active_player => player)
      gs_current.requires_confirmation?.should be_false
    end

    it 'should  require confirmation if the last two game states have a different active player' do
      p0 = Factory.create(:player)
      p1 = Factory.create(:player)
      gs_original = GameState.create!(:active_player => p0)
      gs_current = GameState.create!(:previous => gs_original, :active_player => p1)
      gs_current.requires_confirmation?.should be_true
    end

    describe '#confirmer' do
      it 'should return the user who can confirm' do
        p0 = Factory.create(:player)
        p1 = Factory.create(:player)
        gs_original = GameState.create!(:active_player => p0)
        gs_current = GameState.create!(:previous => gs_original, :active_player => p1)
        gs_current.confirmer.should == p0
      end
    end

    it 'should not require confirmation if the last two game states' +
      'have a different active player, but the last state has' +
      'already been confirmed' do
      p0 = Factory.create(:player)
      p1 = Factory.create(:player)
      gs_original = GameState.create!(:active_player => p0)
      gs_current = GameState.create!(:previous => gs_original, :active_player => p1, :confirmed => true)
      gs_current.requires_confirmation?.should be_false
    end

    it 'should not require confirmation for a game state with no previous' do
      player = Factory.create(:player)
      gs = GameState.create!(:active_player => player)
      gs.requires_confirmation?.should be_false
    end
  end

  describe '#confirm!' do
    it 'should mark the record as confirmed' do
      p0 = Factory.create(:player)
      p1 = Factory.create(:player)
      gs_original = GameState.create!(:active_player => p0)
      gs_current = GameState.create!(:previous => gs_original, :active_player => p1)
      gs_current.confirm!
      GameState.find(gs_current).confirmed.should == true
    end
  end
end
