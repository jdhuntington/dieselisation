require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DashboardsController do

  describe '#show' do
    it 'should show the users current games' do
      game = Factory.create(:game, :status => 'new')
      user = Factory.create(:user)
      game.users << user
      @controller.current_user = user
      get :show
      assigns[:games].should == [game]
    end
    it 'should redirect to the login if no user is logged in' do
      get :show
      response.should be_redirect
    end
  end
end
