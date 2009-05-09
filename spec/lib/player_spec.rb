require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
      bank.expects(:sell).with(asset, 50).returns(true)
      player = Player.new(:balance => 133)
      player.buy(asset, bank, 50)
      player.balance.should == 83
    end

    it 'should add the item to it\'s own inventory' do
      bank = mock 'bank'
      asset = mock 'asset'
      bank.stubs(:sell)
      player = Player.new(:balance => 133)
      player.buy(asset, bank, 50)
      player.assets.should == [asset]
    end
  end
end
