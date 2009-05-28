require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GamesController do

  describe '#new' do
    it 'should return success' do
      user = Factory.create(:player)
      session[:user_id] = user.id
      
      get :new
      response.should be_success
    end

    it 'should redirect to the login if no user is logged in' do
      get :new
      response.should be_redirect
    end
  end

  describe '#create' do
    it 'should let a user create a game' do
      user = Factory.create(:player)
      session[:user_id] = user.id
      post :create, :game => { :name => 'my_game' }
      response.should be_redirect
    end

    it 'should set the flash message' do
      user = Factory.create(:player)
      session[:user_id] = user.id
      post :create, :game => { :name => 'my_game' }
      flash[:notice].should include("successfully")
    end
    
  end

  describe '#show' do
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
      @game = Factory.create(:game)
    end
    
    it 'should make the game available to the template' do
      get :show, :id => @game.id
      assigns[:game].should == @game
    end
    
  end

  describe '#index' do
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
      @games = [Factory.create(:game), Factory.create(:game)]
    end

    it 'should show all games that are not finished' do
      game = Factory.create(:game)
      game.status = 'finished'
      game.save!
      get :index
      assigns[:games].should_not include(game)
      assigns[:games].length.should == 2
    end
  end
end
