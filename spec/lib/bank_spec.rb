$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib', 'game')
require 'bank'

describe Bank do
  it 'should be a singleton' do # Is this enforceable in ruby?
    Bank.instance.should == Bank.instance
  end
end
