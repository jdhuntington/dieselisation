require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  
  describe '#new' do
    it 'should respond successfully' do
      get :new
      response.should be_success
    end
  end

  describe '#create_remote' do
    it 'should locate a user by identifier' do
      u = User.create!(:identifier => 'abc')
      $rpx.expects(:auth_info).with('xyz').returns({ 'identifier' => "abc"} )
      get :create_remote, :token => 'xyz'
      session[:user_id].should == u.id
    end

    it 'should redirect to the dashboard' do
      u = User.create!(:identifier => 'abc')
      $rpx.stubs(:auth_info).returns({ 'identifier' => "abc"} )
      get :create_remote, :token => 'xyz'
      response.should be_redirect
    end

    it 'should create a new user with display name if one did not exist' do
      $rpx.expects(:auth_info).with('xyz').returns({ 'identifier' => "abc", 'displayName' => 'jimbob' })
      get :create_remote, :token => 'xyz'
      u = User.find_by_identifier('abc')
      u.username.should == 'jimbob'
    end
  end
end
