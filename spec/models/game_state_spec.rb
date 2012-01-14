require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GameState do
  describe 'statefulness' do
    before do
      @game = Factory.create(:game)
      @player = Factory.create(:player)
      @game.stubs(:current_player).returns(@player)
    end

    describe '#act' do
      it 'should apply the action to the game instance'
      it 'should create a new game state for game'
    end

    describe '#game_instance' do
      it 'should return an instance with all previous actions applied'
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
