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

  describe 'transactions' do
    it 'should be able to purchase an asset from the bank' do
      bank = mock 'bank'
      asset = mock 'asset'
      player = Player.new(:balance => 133)
      player.buy(asset, bank, 50)
      player.balance.should == 83
    end

  end
end
