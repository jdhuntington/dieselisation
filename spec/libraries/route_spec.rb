require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dieselisation::Route do
  before :each do
    @company = Dieselisation::Company.new('Huntington Transport')
    @a = Dieselisation::Node.new(:value => 20, :tokens => [@company], :whistle_stop => true)
    @b = Dieselisation::Node.new(:value => 20, :whistle_stop => true)
    @c = Dieselisation::Node.new
  end
  
  it 'should return 0 for an empty map' do
    map = Dieselisation::Map.new
    Dieselisation::Route.optimal(map, @company).should == 0
  end

  it 'should return 40 with a 2-train, a tokened city connected to another city' do
    map = Dieselisation::Map.new({
                                   :nodes => [@a,@b],
                                   :connections => [[@a,@b]]
                                 })
    Dieselisation::Route.optimal(map, @company).should == 40
  end

  it 'should return 0 with a 2-train, and no tokened cities connected to another city' do
    map = Dieselisation::Map.new({
                                   :nodes => [@a,@c],
                                   :connections => [[@a,@c]]
                                 })
    Dieselisation::Route.optimal(map, @company).should == 0
  end

  it 'should return 0 with a 2-train and no connections' do
    map = Dieselisation::Map.new(:nodes => [@a])
    Dieselisation::Route.optimal(map, @company).should == 0
  end
end

