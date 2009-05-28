require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe '#current_games' do
    it 'should load all current games' do
      g0 = Factory.create(:game, :status => 'finished')
      g1 = Factory.create(:game, :status => 'abandoned')
      g2 = Factory.create(:game, :status => 'active')
      g3 = Factory.create(:game, :status => 'new')
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
