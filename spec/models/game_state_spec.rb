require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GameState do
  describe 'saving state' do
    it 'should marshal the game state before save' do
      g = Factory.create(:game)
      p = Factory.create(:player)
      g.stubs(:current_player).returns(p)
      gs = GameState.new(:game => g)
      gs.game_instance = :something
      Marshal.expects(:dump).with(:something).returns('some_data')
      gs.save!
      assert_equal 'some_data', GameState.find(gs.id).game_state
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
