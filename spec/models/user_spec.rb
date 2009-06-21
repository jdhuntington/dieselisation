require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe '#current_games' do
    it 'should load all current games' do
      g0 = Factory.create(:game)
      g1 = Factory.create(:game)
      g2 = Factory.create(:game)
      g3 = Factory.create(:game)
      u = Factory.create(:player)
      u0 = Factory.create(:player)
      u1 = Factory.create(:player)
      [g0,g1,g2,g3].each do |g|
        g.add_player u0
        g.add_player u1
        g.add_player u
        g.start!
      end
      g1.status = 'finished'; g1.save!
      g0.status = 'finished'; g0.save!
      current = u.current_games
      current.length.should == 2
      current.include?(g2).should be_true
      current.include?(g3).should be_true
    end
  end

  describe '#in_game?' do
    before(:each) do
      @user = Factory.create(:player)
    end
    
    it 'should respond false if player is not in game' do
      game = Factory.create(:game)
      @user.in_game?(game).should == false
    end

    it 'should respond true if player is in game' do
      game = Factory.create(:game)
      game.users << @user
      @user.in_game?(game).should == true
    end
  end

  describe 'user-friendly sorting' do
    before(:each) do
      @user = Factory.create(:player)
    end
    
    it 'should aggregate my games into neat little sections' do
      @user.stubs(:active_games_waiting_on_me).returns([1])
      @user.stubs(:active_games_not_waiting_on_me).returns([2])
      @user.stubs(:unstarted_games).returns([3])
      @user.stubs(:finished_games).returns([4])
      @user.current_games_preferred_list.should == [1,2,3,4]
    end
  end
end
