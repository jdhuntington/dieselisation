require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'bank'

describe Bank do
  it 'should be a singleton' do # Is this enforceable in ruby?
    Bank.instance.should == Bank.instance
  end

  it 'should have a balance' do
    Bank.instance.init(:balance => 99)
    Bank.instance.balance.should == 99
  end

  it 'should have assets' do
    Bank.instance.init(:balance => 99)
    Bank.instance << :some_asset
    Bank.instance.assets.should == [:some_asset]
  end
end
