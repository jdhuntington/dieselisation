$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib', 'game')
require 'bank'

describe Bank do
  it 'should be a singleton' do # Is this enforceable in ruby?
    Bank.instance.should == Bank.instance
  end

  it 'should have a balance' do
    Bank.instance.init(:balance => 99)
    Bank.instance.balance.should == 99
  end
end
