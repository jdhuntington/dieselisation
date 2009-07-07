require "test/unit"
require 'yaml'

require "../dieselisation"
Dir.glob('../dieselisation/*.rb').each do |mod|
  require mod
end
require "../implementations/game_18ga"

ActionStub = Struct.new(:name, :par)
class TestAction < Test::Unit::TestCase
  def test_buy_private_action_should_describe_itself
    private = ActionStub.new('foobar', 9)
    a = Dieselisation::Action.new(:buy_private, private)
    assert_equal "Buy foobar ($9)", a.description
  end
end
