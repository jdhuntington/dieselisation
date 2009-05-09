require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'certificate'

describe Certificate do
  it 'should have a company' do
    cert = Certificate.new(:a_company, :owner)
    cert.company.should == :a_company
  end

  it 'should have a value' do
    cert = Certificate.new(:a_company, :owner, :value => 50)
    cert.value.should == 50
  end

  it 'should have an owner' do
    cert = Certificate.new(:a_company, :owner)
    cert.owner.should == :owner
  end
  
  describe 'number of shares' do
    it 'should be 1 for a normal certifcate' do
      cert = Certificate.new(:a_company, :owner)
      cert.shares.should == 1
    end
    it 'should be 2 for a president\'s certifcate' do
      pres_cert = Certificate.new(:a_company, :owner, :shares => 2)
      pres_cert.shares.should == 2
    end
  end
end
