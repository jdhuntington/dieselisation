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
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
    end
    
    it 'should redirect to the new form with a flash message if the game is not valid' do
      game = Factory.create(:game, :name => 'my_game')
      post :create, :game => { :name => 'my_game' }
      assigns[:game].should have(1).errors_on(:name)
      response.should render_template("games/new")
    end
    
    it 'should let a user create a game' do
      post :create, :game => { :name => 'my_game' }
      response.should be_redirect
    end

    it 'should set the flash message' do
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

  describe '#join' do
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
      @game = Factory.create(:game)
    end

    it 'should add the player to the game and redirect' do
      post :join, :id => @game.id
      @user.games.should include(@game)
      response.should be_redirect
    end

    it 'should show an error and redirect if the player attempts to join twice' do
      @game.users << @user
      post :join, :id => @game.id
      flash[:error].should include("already")
      response.should be_redirect
    end
  end

  describe '#edit' do
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
      @game = Factory.create(:game)
    end
    
    it 'should assign the game and respond successfully' do
      get :edit, :id => @game.id
      response.should be_success
      assigns[:game].should == @game
    end
  end

  
  describe '#update' do
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
      @game = Factory.create(:game)
    end
    
    it 'should redirect to the edit form with a flash message if the game is not valid' do
      game = Factory.create(:game, :name => 'my_game')
      put :update, :id => @game.id, :game => { :name => 'my_game' }
      assigns[:game].should have(1).errors_on(:name)
      response.should render_template("games/edit")
    end
    
    it 'should let a user create a game' do
      put :update, :id => @game.id, :game => { :name => 'my_game' }
      response.should be_redirect
    end

    it 'should set the flash message' do
      put :update, :id => @game.id, :game => { :name => 'my_game' }
      flash[:notice].should include("successfully")
    end
  end
end
