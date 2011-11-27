require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.join(Rails.root, 'lib', 'dieselisation'))

describe Dieselisation::Map do
  it 'should give me an array containing the connections' do
    a = Dieselisation::Node.new
    b = Dieselisation::Node.new
    c = Dieselisation::Node.new
    d = Dieselisation::Node.new

    map = Dieselisation::Map.new(:nodes => [a,b,c,d],
                                 :connections => [[a,b],[b,c],[c,d],[d,a]])
    map.connections_to(a).should == [b,d]
  end

  it 'should give me an empty array if there are no good connections' do
    a = Dieselisation::Node.new
    b = Dieselisation::Node.new
    c = Dieselisation::Node.new
    d = Dieselisation::Node.new
    e = Dieselisation::Node.new

    map = Dieselisation::Map.new(:nodes => [a,b,c,d],
                                 :connections => [[a,b],[b,c],[c,d],[d,a]])
    map.connections_to(e).should == []
  end
  
end

