require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dieselisation::Player do
  describe "#available_balance" do
    it 'should return the balance less the total amount of bids' do
      p = Dieselisation::Player.new(:balance => 100)
      p.stubs(:bids_total).returns(27)
      p.available_balance.should == 73
    end
  end
end

