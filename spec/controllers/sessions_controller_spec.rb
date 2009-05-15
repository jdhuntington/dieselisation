require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  
  describe '#new' do
    it 'should respond successfully' do
      get :new
      response.should be_success
    end
  end
end
