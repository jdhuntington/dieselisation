require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Game do
  describe 'active games' do
    it 'should have a current player' do
      g = Factory(:game)
      u0, u1 = Factory(:player), Factory(:player)
      g.users << u0
      g.users << u1
      g.current_player = u0
      g.reload
      g.current_player.should == u0
    end
  end
end
