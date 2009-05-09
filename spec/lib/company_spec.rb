require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'company'

def company_factory()
  ['ABC Railroad']
end

describe Company do
  describe 'info' do
    it 'should have a name' do
      c = Company.new('ABC Railroad')
      c.name.should == 'ABC Railroad'
    end
  end

  describe 'treasury' do
    it 'should have a balance' do
      c = Company.new(*company_factory)
      c.balance.should == 0
    end
  end

  describe 'shares' do
    it 'should have 10' do
      c = Company.new(*company_factory)
      c.shares.length.should == 10
    end
  end

  describe 'president' do
    it 'should not exist if no shares have been purchased' do
      c = Company.new(*company_factory)
      c.president.should be_nil
    end
  end
end
