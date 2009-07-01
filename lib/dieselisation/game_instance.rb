require File.expand_path(File.dirname(__FILE__) + '/map_parser')

module Dieselisation
  class GameInstance < Base
    attr :players
    attr_reader :num_players, :privates, :p_opts
    
    SR = 'stock round'
    OR = 'operating round'
    
    def initialize(implementation, players)
      @implementation = implementation
      @num_players = players.length
      setup_players(players)
      @priority = @players['id1']
      @current_player = @priority
      @current_round = @implementation::CONFIG[:rounds][0]
      @current_phase = @implementation::CONFIG[:phases][0]
      setup_privates
      setup_bank
      @p_opts = @implementation::CONFIG[:player_options]
      
      parse_map!
    end
    
    def board
      @board
    end
    
    def bank
      @bank
    end
    
    def priority
      @priority
    end
    
    def current_player
      @current_player
    end
    
    def current_round
      @current_round
    end
    
    def current_phase
      @current_phase
    end
    
    def next_player
      # this will need a lot more conditions
      options = player_options
      if options.keys == [:private_auction_bid, :private_auction_pass]
        pvt_for_auction = options[:private_auction_bid][:private]
        # only players who have bid on the private, 
        #   in seat order starting with the player after
        #   the one who made the highest bid

        @current_player = iterate_players(pvt_for_auction.bidders, 
                                          pvt_for_auction.highest_bidder)
        return @current_player
      end
            
      num = @current_player.seat_order + 1
      if num == @players.length + 1
        num = 1
      end
      @players.each do |id,p|
        if p.seat_order == num
          @current_player = p
          break
        end        
      end
    end
    
    # takes the list of relavant players and the index of current one.  
    # Returns the next.
    # allows for iteration over a subset of players, for auctions, etc.
    def iterate_players(list, current)
      if list.include?(current)
        num = list.index(current) + 1
        if num == list.length
          num = 0
        end
        # puts "#{list.length}, #{num}"
        list[num]
      else
        false
      end
    end
    
    # this is very 18GA specific
    # this is becoming the main event loop for the game.  I expect it
    # to be called frequently and can then invoke any non-player actions
    # and events that need to happen given the current game state
    def player_options
      options = {}
      if @current_round == SR
        if (@bank.assets.map { |a| a.class == Dieselisation::Private }).include?(true)
          # the bank still owns a private
          cheapest_pvt = @bank.cheapest_private
          if auction_private
            options[:private_auction_bid] = {:players => cheapest_pvt.bidders, 
                                             :private => cheapest_pvt}
            options[:private_auction_pass] = options[:private_auction_bid]
            return options  
          elsif cheapest_pvt.bids.empty?
            # no bid on the cheapest private
            options[:buy_private] = {:player => @current_player, :private => cheapest_pvt}
          end
          options[:bid_on_private] = {:player => @current_player, 
                                      :privates => @bank.assets - [cheapest_pvt]}
        end
        
      elsif @current_round == OR
        
      else
        raise 'Unknown round.'
      end
      
      return options
    end
    
    # returns false if the private was bought or no auction
    # true if the bidding will continue
    # probably should be protected
    def auction_private
      asset = @bank.cheapest_private
      unless asset.bids.empty?
        if asset.bids.length == 1
          # only 1 bidder auto buys
          asset.bids[0][:player].buy(asset, @bank, asset.bids[0][:price])
          asset.clear_bids
          asset.bidders.each  { |b| b.clear_bids }
          return false
        else
          return true
        end
      else
        false
      end
    end
    
    protected
    def parse_map!
      require @implementation::MAPFILE
      @board = ::Dieselisation.get_board
      @board.normalize!
    end
    
    def setup_players(players)
      @players = {}
      starting_cash = @implementation::CONFIG[:player_init][@num_players][:start_money]
      order = (1..@num_players).to_a.sort{rand}
      players.each do |player|
        seat = order.shift
        @players["id#{seat}"] = Player.new({:name => player, :balance => starting_cash,
                                   :seat_order => seat, :identifier => player.object_id})
      end
    end
    
    def setup_privates
      @privates = {}
      @implementation::CONFIG[:private_companies].each do |id, p|
        @privates[id] = Private.new({:name => p[:name], :par => p[:par], 
                                    :revenue => p[:revenue], :special => p[:special]})
      end
    end
    
    def setup_bank
      starting_balance = @implementation::CONFIG[:bank] - 
                                  (@players['id1'].balance * num_players)
      @bank = Bank.new({:balance => starting_balance})
      @privates.each do |k, v|
        @bank << v
      end
    end
  end
end
