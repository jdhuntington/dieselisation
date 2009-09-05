require "test/unit"
require 'yaml'
require 'rubygems'
require 'mocha'

require "../dieselisation"
Dir.glob('../dieselisation/*.rb').each do |mod|
  require mod
end

class TestGameFlow < Test::Unit::TestCase
  GA = YAML.load_file('../dieselisation/18GA/game_18ga.yml')
  PLAYERS = [1337,42,0xDEADBEEF,13] # The game instance expects an array of player ids from the rails app
  NUM_PLAYERS = PLAYERS.length
  PLAYER_INIT = GA[:player_init][NUM_PLAYERS]

  def test_player_setup
    PLAYERS.each do |id|
      # puts player.inspect
      player = Dieselisation::Player.new({:identifier => id, 
                                        :balance => PLAYER_INIT[:start_money]})                                     
      assert_equal 450, player.balance
      assert_equal [], player.assets
    end
  end
  
  # For association with the logged in user
  def test_player_should_keep_track_of_a_unique_identifier 
    p = Dieselisation::Player.new({ :identifier => "abcdef"})
    assert_equal("abcdef", p.identifier)
  end
  
  def test_bank
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    assert(inst.bank.balance == 6200)
    assert(inst.bank.withdrawl(200) == 6000)
    assert(inst.bank.deposit(325) == 6325)
    
    assert(inst.bank.assets.length == 5)
    assert_equal(inst.bank.assets[0].class, Dieselisation::Private)
    
    private_ref = inst.bank.assets[1]
    my_private = inst.bank.sell(private_ref, 100)
    assert(private_ref == my_private)
    assert(inst.bank.assets.length == 4)
    assert(inst.bank.balance == 6425)

    assert_equal(20, inst.bank.cheapest_private.par)
  end
  
  def test_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    assert(inst.players[2].balance == 450)
    pvt = inst.privates[1]
    assert(!(inst.current_player.bid_on_private(pvt, 30)))
    assert(!(inst.current_player.bid_on_private(pvt, 452)))
    assert(inst.current_player.bid_on_private(pvt, 40))
    assert_equal(pvt.bidders, [inst.current_player])
    pvt2 = inst.privates[2]
    assert(!(inst.current_player.bid_on_private(pvt2, 412)))
    assert(inst.current_player.bid_on_private(pvt2, 400))
    assert_equal(inst.current_player.bids_total, 440)
  end
  
  def test_private
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    next_player = inst.players[1]
    assert_equal(inst.privates[1].highest_bid, 35)
    assert_equal(inst.privates[1].bid(inst.current_player, 40), 
                    [{:price => 40, :player => inst.current_player}])
    assert_equal(inst.privates[1].highest_bid, 40)
    assert(!(inst.privates[1].bid(inst.current_player, 42)))
    assert_equal(inst.privates[1].bid(next_player, 45), 
                    [{:price => 40, :player => inst.current_player},
                     {:price => 45, :player => next_player}])
    assert_equal(inst.privates[1].bidders, [inst.current_player, next_player])

    inst.current_player.buy(inst.privates[0], inst.bank, inst.privates[0].par)
    
    assert_equal(inst.bank.cheapest_private, inst.privates[1])
  end

  def test_game_4p_setup
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    assert(inst.num_players == 4)
    
    assert(inst.privates.length == 5)
    assert_equal(inst.privates[0].par, 20)
    assert(inst.privates[2].bids == [])

    assert_equal(inst.current_round, Dieselisation::GameInstance::SR)
    assert(inst.current_phase == 1)
  end
    
  def test_game_instance_initial_state
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    opts = inst.player_options # initial options
    assert_equal(Array, opts.class)
    cheap_private = opts.detect {|o| o.type == :buy_private}
    assert_equal('Lexington Terminal RR', cheap_private.target.name)
    assert_equal(1, (opts.find_all {|o| o.type == :buy_private}).length)
    assert_equal(4, (opts.find_all {|o| o.type == :bid_on_private}).length)
    
    assert(inst.bank.assets.include?(cheap_private.target))
    
    player_options_keys = inst.player_options.map { |opt| opt.type }
    
    cheap_private = inst.player_options.detect { |opt| opt.type == :buy_private }.target
    assert_equal(cheap_private.name, 'Lexington Terminal RR')
    assert(inst.bank.assets.include?(cheap_private))
  end
  
  def test_game_instance_next_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    p1 = inst.current_player
    inst.next_player
    p2 = inst.current_player
    assert(!(p1 == p2))
    inst.next_player
    p3 = inst.current_player
    assert(!(p2 == p3))
    inst.next_player
    p4 = inst.current_player
    assert(!(p3 == p4))
    inst.next_player
    assert(p1 == inst.current_player)
  end
  
  def test_buy_private
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    cup = inst.current_player
    # puts inst.player_options.inspect
    cheap_private = inst.player_options.detect { |opt| opt.type == :buy_private }.target
    cup.buy(cheap_private, inst.bank, cheap_private.par)
    assert_equal(cup.balance, 430)
    assert(cup.assets.include?(cheap_private))
    assert(!(inst.bank.assets.include?(cheap_private)))
    assert_equal(inst.bank.balance, 6220)
    player_options_keys = inst.player_options.map { |opt| opt.type }
    assert(player_options_keys.include?(:bid_on_private))
    assert(player_options_keys.include?(:buy_private))
  end
    
  def test_buy_private_trigger_auction
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    p1 = inst.current_player
    cheap_private = inst.player_options.detect { |opt| opt.type == :buy_private }.target
    # p1 buys cheapest private
    p1.buy(cheap_private, inst.bank, cheap_private.par)
    inst.next_player
    assert(!(inst.current_player == p1))
    p2 = inst.current_player
    # p2 bids on wsr
    assert(inst.privates[2].bid(p2, 75))
    options = inst.player_options
    player_options_keys = options.map { |opt| opt.type }
    assert(player_options_keys.include?(:bid_on_private))
    assert(player_options_keys.include?(:buy_private))
    inst.next_player
    assert(!(inst.current_player == p2))
    p3 = inst.current_player
    cheapest_private = inst.player_options.detect { |opt| opt.type == :buy_private }.target
    price = cheapest_private.par
    #p3 buys cheapest private
    p3.buy(cheapest_private, inst.bank, price)
    assert_equal(p3.balance, 450 - price)
    assert(p3.assets.include?(cheapest_private))
    assert(!(inst.bank.assets.include?(cheap_private)))
    assert_equal(inst.bank.balance, 6220 + price)
    # should trigger immediate buy of wsr by p2
    # assert_equal(inst.player_options.keys, [:private_auction_bid, :private_auction_pass])
    options = inst.player_options
    player_options_keys = options.map { |opt| opt.type }
    assert(player_options_keys.include?(:bid_on_private))
    assert(player_options_keys.include?(:buy_private))
    assert_equal(inst.auction_private, false)
    assert(p2.assets.include?(inst.privates[2]))
    assert_equal(p2.balance, 450 - 75)
    assert_equal(p2.bids_total, 0)
  end
  
  def test_instance_iterate_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    p1 = inst.current_player
    p2 = inst.send(:iterate_players, inst.players.map {|p| p}, p1)
    assert_equal(p2, inst.players[1])
    p3 = inst.send(:iterate_players, inst.players.map {|p| p}, p2)
    assert_equal(p3, inst.players[2])
    p4 = inst.send(:iterate_players, inst.players.map {|p| p}, p3)
    assert_equal(p4, inst.players[3])
    np = inst.send(:iterate_players, inst.players.map {|p| p}, p4)
    assert_equal(np, p1)
  end

  # TODO finish
  def test_private_auction
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    p1 = inst.current_player
    mid = inst.privates[1]
    # players 1-3 bid on mid
    assert(p1.bid_on_private(mid, 70))
    assert(inst.next_player)
    p2 = inst.current_player
    assert(p2.bid_on_private(mid, 75))
    inst.next_player
    p3 = inst.current_player
    assert(p3.bid_on_private(mid, 85))
    assert_equal(mid.bids.length, 3)
    assert_equal(mid.highest_bidder, p3)
    inst.next_player
    p4 = inst.current_player
    # p4 buys ltr
    cheap_private = (inst.player_options.detect {|o| o.type == :buy_private}).target
    p4.buy(cheap_private, inst.bank, cheap_private.par)
    # auction for mid starts with other 3 players
    assert(inst.next_player)
    options = inst.player_options
    option_keys = options.map { |opt| opt.type }
    assert(option_keys.include?(:private_auction_bid))
    assert(option_keys.include?(:private_auction_pass))
    assert_equal(options[0].target, options[1].target)
    assert_equal(options[0].target, mid)
    assert_equal(mid.bidders, [p1, p2, p3])
    # p1 starts the bidding
    assert_equal(inst.current_player, p1)
    assert(p1.bid_on_private(mid, 90)) # p1 bid
    assert_equal(mid.highest_bid, 90)
    assert(inst.next_player)
    options = inst.player_options
    option_keys = options.map { |opt| opt.type }
    assert(option_keys.include?(:private_auction_bid))
    assert(option_keys.include?(:private_auction_pass))
    assert_equal(options[0].target, options[1].target)
    assert_equal(options[0].target, mid)
    assert_equal(p2, inst.current_player)
    # p2 passes - stays in the bidding
    assert(inst.current_player.pass(mid))
    assert_equal({:player => p2, :price => 0}, mid.bids.last)
    assert(inst.next_player)
    # options = inst.player_options
    
end
  
  def test_inst_everybody_passed_on_a_turn
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    assert(!(inst.everybody_passed?))
    ltr = inst.privates[0]
    # assert(ltr.)
    
  end
  
  def test_current_player_should_return_first_player_from_players_list
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    assert_equal inst.current_player, inst.players.first
  end

  def test_next_player_should_progress_the_player_track_so_that_the_first_player_is_now_the_last_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    players = inst.players
    first_player = players[0]
    second_player = players[1]
    inst.next_player
    assert_equal second_player, inst.players.first
    assert_equal first_player, inst.players.last
  end

  def test_go_to_next_player_skipping_checks_should_shift_the_current_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    players = inst.players
    first_player = players[0]
    second_player = players[1]
    inst.send(:go_to_next_player_skipping_checks!)
    assert_equal second_player, inst.players.first
    assert_equal first_player, inst.players.last
  end

  def test_current_player_identifier_should_return_the_identifier_of_the_current_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    inst.stubs(:current_player).returns(stub_everything('player', :identifier => :theid))
    assert_equal :theid, inst.current_player_identifier
  end

  def test_ga_should_load_the_privates_in_order
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    actual_private_nicknames = inst.bank.privates.map { |priv| priv.nickname }
    expected_private_nicknames = %w{ ltr mid wsr osr mbr }
    assert_equal expected_private_nicknames, actual_private_nicknames
  end

  def test_handle_bid_should_add_a_bid_to_the_target
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    inst.handle_bid({ 'target' => 'ltr', 'bid' => '300' })
    # get the private
    private = inst.lookup_private 'ltr'
    assert_equal [{:player => inst.current_player, :price => 300}], private.bids
  end

  def test_lookup_private_should_load_the_desired_private
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    assert_not_nil inst.lookup_private('ltr')
  end
end
