require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  
  before(:each) do
    @user = Factory.create(:player)
    session[:user_id] = @user.id
  end
  
  describe '#edit' do
    it 'should show the edit form' do
      get :edit
      response.should render_template('accounts/edit')
    end
  end

  describe '#update' do
    it 'should update some fields' do
      @user.update_attributes!({
                                 :actual_name => 'dontcare',
                                 :username => 'dontcare',
                                 :identifier => 'care',
                                 :email_notification => true
                               })
      put :update, :account => { :actual_name => 'joe', :username => 'foo', :identifier => 'abc', :email_notification => '0' }
      @user.reload
      @user.actual_name.should == 'joe'
      @user.username.should == 'foo'
      @user.identifier.should == 'care'
      @user.email_notification.should == false
    end

    it 'should set the flash' do
      put :update, :account => { :actual_name => 'joe', :username => 'foo', :identifier => 'abc', :email_notification => '0' }
      flash[:notice].should include("successfully")
    end
    it 'should redirect to the edit form' do
      put :update, :account => { :actual_name => 'joe', :username => 'foo', :identifier => 'abc', :email_notification => '0' }
      response.should redirect_to(:action => 'edit')
    end
  end
end

