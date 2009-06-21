require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GameState do
  describe 'saving state' do
    it 'should marshal the game state before save' do
      gs = GameState.new
      gs.game_instance = :something
      Marshal.expects(:dump).with(:something).returns('some_data')
      gs.save!
      assert_equal 'some_data', GameState.find(gs.id).game_state
    end
  end
end
