require "test/unit"
require 'yaml'

require "../dieselisation"
Dir.glob('../dieselisation/*.rb').each do |mod|
  require mod
end
require "../implementations/game_18ga"

class TestGameFlow < Test::Unit::TestCase
  INST = YAML.load_file('test_18ga.yml')
  GA = YAML.load_file('../implementations/18GA/game_18ga.yml')
  NUM_PLAYERS = INST[:players].length
  PLAYER_INIT = GA[:player_init][NUM_PLAYERS]
  PLAYERS = INST[:players].map {|p| p[1][:name]}

  def test_fixture_data
    assert(INST.class == Hash, INST.class)
    assert(INST.has_key?(:players), INST.keys)
    assert(PLAYER_INIT[:start_money] == 450, PLAYER_INIT[:start_money].inspect)
    assert(PLAYER_INIT[:certificate_limit] == 12, PLAYER_INIT[:certificate_limit].inspect)
  end
  
  def test_player_setup
    seat = {}
    INST[:players].each do |id, player|
      # puts player.inspect
      seat[id] = Dieselisation::Player.new({:name => player[:name], 
                                        :balance => PLAYER_INIT[:start_money]})                                     
      assert(seat[id].name == player[:name], seat[id].name + ', ' + player[:name])
      assert(seat[id].balance == 450, seat[id].balance)
      assert(seat[id].assets == [], seat[id].assets)
    end
    assert(PLAYERS.include?(seat['id1'].name))
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
    assert(inst.players['id3'].balance == 450)
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
    next_player = inst.players['id2']
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
    puts PLAYERS.inspect
    assert(PLAYERS.include?(inst.players['id1'].name), inst.players['id1'].inspect)
    
    assert(inst.privates.length == 5)
    assert_equal(inst.privates['ltr'].par, 20)
    assert(inst.privates['osr'].name == 'Ocilla Southern RR')
    assert(inst.privates['wsr'].bids == [])
    
    assert_not_equal(inst.players['id1'].seat_order, inst.players['id2'].seat_order)
    assert_not_equal(inst.players['id3'].seat_order, inst.players['id4'].seat_order)
    inst.players.each { |k,v| print "#{v.name}, "}
    assert(inst.priority == inst.players['id1'])
    assert_equal(inst.current_player, inst.players['id1'])
    assert_equal(inst.current_round, Dieselisation::GameInstance::SR)
    assert(inst.current_phase == 1)
  end
    
  def test_game_instance
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, INST[:players])
    assert(inst.player_options.keys.include?(:bid_on_private))
    assert(inst.player_options.keys.include?(:buy_private))
    assert_equal(inst.player_options[:buy_private][:player], inst.current_player)
    cheap_private = inst.player_options[:buy_private][:private]
    assert_equal(cheap_private.name, 'Lexington Terminal RR')
    assert(inst.bank.assets.include?(cheap_private))
  end
  
  def test_game_instance_next_player
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, INST[:players])
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
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, INST[:players])
    cup = inst.current_player
    cheap_private = inst.player_options[:buy_private][:private]
    cup.buy(cheap_private, inst.bank, cheap_private.par)
    assert_equal(cup.balance, 430)
    assert(cup.assets.include?(cheap_private))
    assert(!(inst.bank.assets.include?(cheap_private)))
    assert_equal(inst.bank.balance, 6220)
    assert(inst.player_options.keys.include?(:bid_on_private))
    assert(inst.player_options.keys.include?(:buy_private))
  end
    
  def test_buy_private_trigger_auction
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, INST[:players])
    p1 = inst.current_player
    cheap_private = inst.player_options[:buy_private][:private]
    # p1 buys cheapest private
    p1.buy(cheap_private, inst.bank, cheap_private.par)
    inst.next_player
    assert(!(inst.current_player == p1))
    p2 = inst.current_player
    # p2 bids on wsr
    assert(inst.privates['wsr'].bid(p2, 75))
    options = inst.player_options
    assert(options.keys.include?(:bid_on_private))
    assert(options.keys.include?(:buy_private))
    inst.next_player
    assert(!(inst.current_player == p2))
    p3 = inst.current_player
    price = options[:buy_private][:private].par
    #p3 buys cheapest private
    p3.buy(options[:buy_private][:private], inst.bank, price)
    assert_equal(p3.balance, 450 - price)
    assert(p3.assets.include?(options[:buy_private][:private]))
    assert(!(inst.bank.assets.include?(cheap_private)))
    assert_equal(inst.bank.balance, 6220 + price)
    assert_equal(inst.player_options.keys, [:auction_private])
    # should trigger immediate buy of wsr by p2
    assert_equal(inst.auction_private, inst.privates['wsr'])
    assert(p2.assets.include?(inst.privates['wsr']))
    assert_equal(p2.balance, 450 - 75)
    assert_equal(p2.bids_total, 0)
  end
  
  def test_private_auction
    inst = Dieselisation::GameInstance.new(Dieselisation::Game18GA, INST[:players])
    p1 = inst.current_player
    mid = inst.privates['mid']
    assert(p1.bid_on_private(mid, 70))
    inst.next_player
    p2 = inst.current_player
    assert(p2.bid_on_private(mid, 75))
    inst.next_player
    p3 = inst.current_player
    assert(p3.bid_on_private(mid, 85))
    assert_equal(mid.bids.length, 3)
    assert_equal(mid.highest_bidder, p3)
    inst.next_player
    p4 = inst.current_player
    cheap_private = inst.player_options[:buy_private][:private]
    p4.buy(cheap_private, inst.bank, cheap_private.par)
    options = inst.player_options
    assert_equal(options.keys, [:auction_private])
    assert_equal(options[:auction_private][:private], mid)
    assert_equal(mid.bidders, [p1, p2, p3])
    inst.next_player
    assert_equal(inst.current_player, p3)
    
  end
  
  
  
end