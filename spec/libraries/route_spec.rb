require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dieselisation::Route do
  before :each do
    @company = Dieselisation::Company.new('Huntington Transport')
    @a = Dieselisation::Node.new(:value => 20, :tokens => [@company], :whistle_stop => true, :nickname => :a)
    @b = Dieselisation::Node.new(:value => 20, :whistle_stop => true, :nickname => :b)
    @c = Dieselisation::Node.new(:nickname => :c)
    @c0 = Dieselisation::Node.new(:nickname => :c0)
    @c1 = Dieselisation::Node.new(:nickname => :c1)
    @c2 = Dieselisation::Node.new(:nickname => :c2)
    @d = Dieselisation::Node.new(:value => 10, :whistle_stop => false, :nickname => :d)
    @e = Dieselisation::Node.new(:value => 30, :whistle_stop => true, :nickname => :e)
  end
  
  it 'should return 0 for an empty map' do
    map = Dieselisation::Map.new
    Dieselisation::Route.optimal(map, @company, [2]).should == 0
  end

  it 'should return 40 with a 2-train, a tokened city connected to another city' do
    map = Dieselisation::Map.new({
                                   :nodes => [@a,@b],
                                   :connections => [[@a,@b]]
                                 })
    Dieselisation::Route.optimal(map, @company, [2]).should == 40
  end

  it 'should return 0 with a 2-train, and no tokened cities connected to another city' do
    map = Dieselisation::Map.new({
                                   :nodes => [@a,@c],
                                   :connections => [[@a,@c]]
                                 })
    Dieselisation::Route.optimal(map, @company, [2]).should == 0
  end

  it 'should return 0 with a 2-train and no connections' do
    map = Dieselisation::Map.new(:nodes => [@a])
    Dieselisation::Route.optimal(map, @company, [2]).should == 0
  end

  it 'should return 30 with a 2-train and a connection between a city and a town' do
    map = Dieselisation::Map.new(:nodes => [@a, @d], :connections => [[@a,@d]])
    Dieselisation::Route.optimal(map, @company, [2]).should == 30
  end

  it 'should return 50 with a 2-train and a connection between two ' +\
    'cities and a town in the middle' do
    map = Dieselisation::Map.new(:nodes => [@a, @d, @b],
                                 :connections => [[@a,@d], [@d,@b]])
    Dieselisation::Route.optimal(map, @company, [2]).should == 50
  end

  it 'should return 70 with a 3-train and 3 cities in line' do
    map = Dieselisation::Map.new(:nodes => [@e, @a, @b, @c0, @c1],
                                 :connections => [
                                                  [@a,@c0],
                                                  [@a,@c1],
                                                  [@c1,@b],
                                                  [@c0,@e],
                                                 ])
    Dieselisation::Route.optimal(map, @company, [3]).should == 70
  end

  it 'should return 50 with a 2-train and 3 cities in line' do
    map = Dieselisation::Map.new(:nodes => [@e, @a, @b, @c0, @c1],
                                 :connections => [
                                                  [@a,@c0],
                                                  [@a,@c1],
                                                  [@c1,@b],
                                                  [@c0,@e],
                                                 ])
    Dieselisation::Route.optimal(map, @company, [2]).should == 50
  end
end
