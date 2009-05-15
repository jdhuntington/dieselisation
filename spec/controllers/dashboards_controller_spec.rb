require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardsController do

  describe '#show' do
    it 'should show the users current games' do
      game = Game.create!(:status => 'waiting')
      user = User.create!
      game.users << user
      session[:user_id] = user.id
      get :show
      assigns[:current_games].should == [game]
    end
  end
end
