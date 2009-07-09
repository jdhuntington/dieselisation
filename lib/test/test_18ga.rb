require "test/unit"
require 'yaml'
require 'rubygems'
require 'mocha'

require "../dieselisation"
Dir.glob('../dieselisation/*.rb').each do |mod|
  require mod
end
require "../implementations/game_18ga"

class TestGameFlow < Test::Unit::TestCase
  GA = YAML.load_file('../implementations/18GA/game_18ga.yml')
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
    # puts p.inspect
    assert_equal("abcdef", p.identifier)
  end
  
  def test_bank
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    assert(inst.bank.balance == 6200)
    assert(inst.bank.withdrawl(200) == 6000)
    assert(inst.bank.deposit(325) == 6325)
    
    assert(inst.bank.assets.length == 5)
    assert_equal(inst.bank.assets[0].class, Dieselisation::Private)
    
    private_ref = inst.bank.assets[0]
    my_private = inst.bank.sell(private_ref, 100)
    assert(private_ref == my_private)
    assert(inst.bank.assets.length == 4)
    assert(inst.bank.balance == 6425)
    
    assert_equal(inst.bank.cheapest_private.par, 20)
  end
  
  def test_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    assert(inst.players[2].balance == 450)
    pvt = inst.privates['mid']
    assert(!(inst.current_player.bid_on_private(pvt, 30)))
    assert(!(inst.current_player.bid_on_private(pvt, 452)))
    assert(inst.current_player.bid_on_private(pvt, 40))
    assert_equal(pvt.bidders, [inst.current_player])
    pvt2 = inst.privates['wsr']
    assert(!(inst.current_player.bid_on_private(pvt2, 412)))
    assert(inst.current_player.bid_on_private(pvt2, 400))
    assert_equal(inst.current_player.bids_total, 440)
  end
  
  def test_private
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    next_player = inst.players[1]
    assert_equal(inst.privates['mid'].highest_bid, 35)
    assert_equal(inst.privates['mid'].bid(inst.current_player, 40), 
                    [{:price => 40, :player => inst.current_player}])
    assert_equal(inst.privates['mid'].highest_bid, 40)
    assert(!(inst.privates['mid'].bid(inst.current_player, 42)))
    assert_equal(inst.privates['mid'].bid(next_player, 45), 
                    [{:price => 40, :player => inst.current_player},
                     {:price => 45, :player => next_player}])
    assert_equal(inst.privates['mid'].bidders, [inst.current_player, next_player])
    
    inst.current_player.buy(inst.privates['ltr'], inst.bank, inst.privates['ltr'].par)
    assert_equal(inst.bank.cheapest_private, inst.privates['mid'])
  end

  def test_game_4p_setup
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    assert(inst.num_players == 4)
    
    assert(inst.privates.length == 5)
    assert_equal(inst.privates['ltr'].par, 20)
    assert(inst.privates['osr'].name == 'Ocilla Southern RR')
    assert(inst.privates['wsr'].bids == [])

    assert_equal(inst.current_round, Dieselisation::GameInstance::SR)
    assert(inst.current_phase == 1)
  end
    
  def test_game_instance
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)

    player_options_keys = inst.player_options.map { |opt| opt.type }
    
    assert(player_options_keys.include?(:bid_on_private))
    assert(player_options_keys.include?(:buy_private))
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
    assert(inst.privates['wsr'].bid(p2, 75))
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
    assert(p2.assets.include?(inst.privates['wsr']))
    assert_equal(p2.balance, 450 - 75)
    assert_equal(p2.bids_total, 0)
  end
  
  def test_instance_iterate_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
    p1 = inst.current_player
    p2 = inst.iterate_players(inst.players.map {|p| p}, p1)
    assert_equal(p2, inst.players[1])
    p3 = inst.iterate_players(inst.players.map {|p| p}, p2)
    assert_equal(p3, inst.players[2])
    p4 = inst.iterate_players(inst.players.map {|p| p}, p3)
    assert_equal(p4, inst.players[3])
    np = inst.iterate_players(inst.players.map {|p| p}, p4)
    assert_equal(np, p1)
  end

  # TODO fix
#   def test_private_auction
#     inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, PLAYERS)
#     p1 = inst.current_player
#     mid = inst.privates['mid']
#     # players 1-3 bid on mid
#     assert(p1.bid_on_private(mid, 70))
#     assert(inst.next_player)
#     p2 = inst.current_player
#     assert(p2.bid_on_private(mid, 75))
#     inst.next_player
#     p3 = inst.current_player
#     assert(p3.bid_on_private(mid, 85))
#     assert_equal(mid.bids.length, 3)
#     assert_equal(mid.highest_bidder, p3)
#     inst.next_player
#     p4 = inst.current_player
#     # p4 buys ltr
#     cheap_private = inst.player_options[:buy_private][:private]
#     p4.buy(cheap_private, inst.bank, cheap_private.par)
#     # auction for mid starts with other 3 players
#     assert(inst.next_player)
#     options = inst.player_options
#     assert_equal(options.keys.sort, [:private_auction_bid, :private_auction_pass])
#     assert_equal(options[:private_auction_bid], options[:private_auction_pass])
#     assert_equal(options[:private_auction_bid][:private], mid)
#     assert_equal(mid.bidders, [p1, p2, p3])
#     # p1 starts the bidding
#     assert_equal(inst.current_player, p1)
#     assert(p1.bid_on_private(mid, 90))
#     assert_equal(mid.highest_bid, 90)
#     assert(inst.next_player)
#     options = inst.player_options
#     assert_equal(options.keys.sort, [:private_auction_bid, :private_auction_pass])
#     assert_equal(options[:private_auction_bid], options[:private_auction_pass])
#     assert_equal(options[:private_auction_bid][:private], mid)
#     assert_equal(p2, inst.current_player)
#     # p2 passes - stays in the bidding
#     assert(inst.current_player.pass(mid))
#     options = inst.player_options
    
    
# end
  
  def test_inst_everybody_passed_on_a_turn
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3])
    assert(!(inst.everybody_passed?))
    ltr = inst.privates['ltr']
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
end
