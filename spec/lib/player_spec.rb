$:.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib', 'game')
require 'player'

describe Player do
  it 'should have a name' do
    p = Player.new(:name => 'johndoe')
    p.name.should == 'johndoe'
  end
end
