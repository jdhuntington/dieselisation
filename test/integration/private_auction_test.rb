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

    # assertions
    @game = Game.find(@game.id)
    # TODO assert balance of bidding player
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
    
    # assertions
    @game = Game.find(@game.id)
    assert_equal @expected_next_player, @game.current_player
    assert_have_no_selector "#privates #private-ltr"
    %w{ mid wsr osr mbr }.each { |nickname| assert_have_selector "#privates #private-#{nickname}" }
  end

  def normal_game
    @game = Factory(:game)
    3.times { @game.add_player Factory(:player) }
    @game.start!
    @players = @game.game_instance.players
  end

  def test_private_auction_should_run_the_private_auction
    normal_game
    player(1).bids(60).on('mid')
    player(2).bids(70).on('wsr')
    player(3).bids(70).on('mid')
    player(1).bids(75).on('wsr')
    player(2).bids(75).on('mid')
    player(3).buys('ltr')
    assert_current_player player(1), :with_options => [:bid, :pass]
    player(1).passes
    assert_current_player player(2), :with_options => [:bid, :pass]
    player(2).bids(80).on('mid')
    assert_current_player player(3), :with_options => [:bid, :pass]    
    player(3).bids(85).on('mid')
    assert_current_player player(1), :with_options => [:bid, :pass]
    player(1).bids(90).on('mid')
    assert_current_player player(2), :with_options => [:bid, :pass]
    player(2).bids(95).on('mid')
    assert_current_player player(3), :with_options => [:bid, :pass]    
    player(3).passes
    assert_current_player player(1), :with_options => [:bid, :pass]
    player(1).passes
    assert_owner private('mid'), player(2)
    assert_current_player player(1)
  end

  # - Bidding too little on a private should result in an error
  # - For sequential privates with bids, second auction should happen
  #   automatically
end
