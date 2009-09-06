require File.dirname(__FILE__) + '/../implementation_test_helper'

ActionStub = Struct.new(:type, :par)
class TestAction < Test::Unit::TestCase
  def test_buy_private_action_should_describe_itself
    private = ActionStub.new('foobar', 9)
    a = Dieselisation::Action.new(:buy_private, private)
    assert_equal "Buy foobar ($9)", a.description
  end

  
end
