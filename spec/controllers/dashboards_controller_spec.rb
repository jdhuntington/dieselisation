require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardsController do

  describe '#show' do
    it 'should show the users current games' do
      game = Factory.create(:game, :status => 'new')
      user = User.create!
      game.users << user
      session[:user_id] = user.id
      get :show
      assigns[:games].should == [game]
    end
    it 'should redirect to the login if no user is logged in' do
      get :show
      response.should be_redirect
    end
  end
end
