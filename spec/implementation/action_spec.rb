require File.dirname(__FILE__) + '/../implementation_test_helper'


describe 'TestAction < Test::Unit::TestCase' do
  ActionStub = Struct.new(:type, :par)
  it 'test_buy_private_action_should_describe_itself' do
    private = ActionStub.new('foobar', 9)
    a = Dieselisation::Action.new(:buy_private, private)
    assert_equal "Buy foobar ($9)", a.description
  end
end
