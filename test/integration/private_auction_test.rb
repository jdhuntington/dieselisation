require File.expand_path(File.dirname(__FILE__) + '/../integration_test_helper')

class PrivateAuctionTest < ActionController::IntegrationTest

  def setup_game(players=4)
    @game = Factory(:game)
    (players - 1).times { @game.add_player Factory(:player) }
    @game.start!
    @current_player = @game.current_player
    @expected_next_player = User.find(@game.game_instance.players[1].identifier)
  end

  def click_and_confirm(button_text)
    click_button button_text
    click_button 'confirm'
  end
  
  def test_private_auction_should_let_me_bid_on_second_cheapest_private
    setup_game

    # actions
    visit login_as_path(:username => @current_player.username)
    visit play_game_path(@game)
    click_and_confirm 'bid-mid'

    # assertions
    @game = Game.find(@game.id)
    assert_equal @expected_next_player, @game.current_player
    assert_have_selector "#private-mid .bids .bid-#{@current_player.id}"
  end

  def test_private_auction_should_let_me_buy_the_cheapest_private
    setup_game
    
    # actions
    visit login_as_path(:username => @current_player.username)
    visit play_game_path(@game)
    # precondition
    assert_have_selector "#privates #private-ltr"
    click_and_confirm 'buy-ltr'
    
    # assertions
    @game = Game.find(@game.id)
    assert_equal @expected_next_player, @game.current_player
    assert_have_no_selector "#privates #private-ltr"
    %w{ mid wsr osr mbr }.each { |nickname| assert_have_selector "#privates #private-#{nickname}" }
  end

  def test_private_auction_error_conditions
    # # 3 players
    #
    # ! New player (p1)
    # - I try to bid too little on the 2nd private, I should see a
    #   nice error message.
    # - I then bid an appropriate amount on the 2nd private.
    #
    # ! New player (p2)
    # - I try to bid the same amount as the first player on the 2nd
    #   private, I should see a nice error message.
    # - I then bid 5 more on the 2nd private.
    #
    # ! New player (p3)
    # - I bid on the 2nd private.
    #
    # ! New player (p1)
    # - I bid on the 2nd private.
    #
    # ! New player (p2)
    # - I bid on the 4th private.
    #
    # ! New player (p3)
    # - I bid on the 4th private.
    #
    # ... I do this on and on until player 3 is out of money
    #
    # ! New player (p1)
    click 'pass'
    click 'confirm'
    #
    # ! New player (p2)
    click 'pass'
    click 'confirm'
    #
    # ! New player (p3)
    click 'pass'
    click 'confirm'
    #
    # # operating round
    #
    # ! New player (p1)
    # - I buy the first private for a bit cheaper.
    # - I bid up on the 2nd private.
    #
    # ! New player (p2)
    # - I pass on the 2nd private.
    #
    # ! New player (p3)
    # - I bid up on the 2nd private.
    #
    # ! New player (p1)
    # - I bid up on the 2nd private.
    #
    # ! New player (p3)
    click 'pass'
    click 'confirm'
    #
    # ! Assertion - p1 has the 2nd private and less cash
  end
end
