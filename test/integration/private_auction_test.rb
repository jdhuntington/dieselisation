require 'integration_test_helper'

class PrivateAuctionTest < ActionController::IntegrationTest
  def test_private_auction_should_let_me_bid_on_second_cheapest_private
    # setup
    @game = Factory(:game)
    3.times { @game.add_player Factory(:player) }
    @game.start!
    @current_player = @game.current_player
    @expected_next_player = User.find(@game.game_instance.players[1].identifier)

    # actions
    visit login_as_path(:username => @current_player.username)
    visit play_game_path(@game)
    click_button 'bid-mid'
    click_button 'confirm'

    # assertions
    @game = Game.find(@game.id)
    assert_equal @expected_next_player, @game.current_player
    assert_have_selector "#private-mid .bids .bid-#{@current_player.id}"
  end

  def test_private_auction_should_let_me_buy_the_cheapest_private
    # setup
    @game = Factory(:game)
    3.times { @game.add_player Factory(:player) }
    @game.start!
    @current_player = @game.current_player
    @expected_next_player = User.find(@game.game_instance.players[1].identifier)
    
    # actions
    visit login_as_path(:username => @current_player.username)
    visit play_game_path(@game)
    # precondition
    assert_have_selector "#privates #private-ltr"
    click_button 'buy-ltr'
    click_button 'confirm'
    
    # assertions
    @game = Game.find(@game.id)
    assert_equal @expected_next_player, @game.current_player
    assert_have_no_selector "#privates #private-ltr"
    %w{ mid wsr osr mbr }.each { |nickname| assert_have_selector "#privates #private-#{nickname}" }
  end
end
