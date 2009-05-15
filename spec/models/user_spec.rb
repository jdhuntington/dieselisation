require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
    }
  end

  describe '#current_games' do
    it 'should load all current games' do
      g0 = Game.create!(:status => 'finished')
      g1 = Game.create!(:status => 'abandoned')
      g2 = Game.create!(:status => 'active')
      g3 = Game.create!(:status => 'waiting')
      u = User.create!
      u.games = [g0,g1,g2,g3]
      u.save!
      current = u.current_games
      current.length.should == 2
      current.include?(g2).should be_true
      current.include?(g3).should be_true
    end
  end
end
