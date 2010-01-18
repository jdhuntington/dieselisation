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
end
