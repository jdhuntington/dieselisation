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
    it 'should show all games that are open for registration' do
      user = Factory.create(:player)
      session[:user_id] = user.id
      Game.expects(:open_for_registration).returns([Factory.create(:game, :name => 'checkforthis')])
      get :index
      assigns[:games].first.name.should == 'checkforthis'
    end
  end

  describe '#join' do
    before(:each) do
      @user = Factory.create(:player)
      session[:user_id] = @user.id
      @game = Factory.create(:game)
    end

    it 'should add the player to the game and redirect' do
      Game.stubs(:find).returns(@game)
      User.stubs(:find).returns(@user)
      @game.expects(:add_player).with(@user)
      post :join, :id => @game.id
      response.should be_redirect
    end

    it 'should show an error and redirect if the player attempts to join twice' do
      @game.users << @user
      post :join, :id => @game.id
      flash[:error].should include("already")
      response.should be_redirect
    end

    it 'should not work if the game is not new' do
      3.times { @game.add_player Factory(:player) }
      @game.start!
      post :join, :id => @game.id
      flash[:error].should include("started")
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
    
    it 'should let a user edit a game' do
      put :update, :id => @game.id, :game => { :name => 'my_game' }
      response.should be_redirect
    end

    it 'should set the flash message' do
      put :update, :id => @game.id, :game => { :name => 'my_game' }
      flash[:notice].should include("successfully")
    end

    it 'should update attributes' do
      put :update, :id => @game.id, :game => { :comment => 'foobar' }
      @game.reload
      @game.comment.should == 'foobar'
    end
  end

  describe '#start' do
    it "should set the game's status to active" do
      game = Factory.create(:game)
      3.times { game.add_player Factory(:player) }
      session[:user_id] = game.owner.id
      put :start, :id => game.id
      game.reload
      game.should be_started
    end

    it 'should only be accessible to the owner' do
      game = Factory.create(:game)
      user = Factory.create(:player)
      session[:user_id] = user.id  
      put :start, :id => game.id
      flash[:error].should include("owner")
      game.reload
      game.should_not be_started
    end
  end

  describe '#act' do
    before :each do
      @game = Factory.create(:game)
      2.times { @game.add_player(Factory.create(:player)) }
      @game.start!
      @current_player = @game.current_player
      @non_current_player = (@game.users - [@current_player]).first
      Game.stubs(:find).returns(@game)
    end
    
    it 'should not allow the a non-current player to make an action' do
      session[:user_id] = @non_current_player.id
      @game.expects(:persist!).never
      put :act, :id => @game.id
      flash[:error].should include("not your turn")      
    end
    
    it 'should allow the game instance\'s current player to make an action' do
      session[:user_id] = @current_player.id
      @game.expects(:persist!)
      @game.stubs(:act)
      put :act, :id => @game.id, :action_data => { 'verb' => 'nop' }
      flash[:notice].should include("saved")
    end

    describe 'while logged in' do
      before :each do
        session[:user_id] = @current_player.id
      end

      it 'should pass the parameters to the game along with the player id' do
        action_info = { 'verb' => 'bid', 'target' => 'mid' }
        @game.expects(:act).with(action_info.merge({ 'player_id' => @current_player.id }))
        put :act, :id => @game.id, :action_data => action_info
      end
    end
  end
end
