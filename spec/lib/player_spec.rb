$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib', 'game')
require 'player'

describe Player do
  it 'should have a name' do
    p = Player.new(:name => 'johndoe')
    p.name.should == 'johndoe'
  end

  it 'should have a balance' do
    p = Player.new(:balance => 50)
    p.balance.should == 50
  end

  it 'should be able to purchase a certificate from the bank'
end
