require File.expand_path(File.dirname(__FILE__) + '/map_parser')

module Dieselisation
  class GameInstance < Base
    attr_accessor :players
    attr_reader :num_players, :privates

    SR = 'stock round'
    OR = 'operating round'

    def initialize(implementation, player_ids, options = {})
      @implementation = implementation.new
      @num_players = player_ids.length
      setup_players(player_ids, :shuffle_players => options[:shuffle_players])
      @current_round = 'SR'
      setup_privates
      setup_bank
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
      @players.first
    end

    def imp_name
      @implementation::CONFIG[:name]
    end

    def current_player_identifier
      current_player.identifier
    end

    # Set the current player
    def current_player=(player) # TODO make sure player is actually a player, avoid loops
      while current_player != player
        go_to_next_player_skipping_checks!
      end
      player
    end

    def current_round
      @current_round
    end

    def current_phase
      @current_phase
    end

    def next_player!
      player = @players.shift   # Get the first player, and take out of the players array
      @players.push(player)     # Put the first player back in the array in last position
      current_player
    end

    def round_name
      'private_auction'
    end

    # TODO implement
    # returns private currently being auctioned
    def private_for_auction
      raise "implement me"
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

    def everybody_passed?(players_involved = num_players)
      asset = @bank.cheapest_private
      if asset.bids.length >= players_involved
        # treat 0 as a pass
        if asset.bids[-(players_involved),players_involved].uniq == 0
          true
        end
      else
        false
      end
    end

    def lookup_private(nickname)
      found = privates.detect{ |p| p.nickname == nickname }
      return found if found
      known = privates.map {|x| x.nickname}
      raise "Unkonwn private #{nickname.inspect}. (Privates are: #{known.inspect})"
    end

    def handle_private_purchase(options)
      # options { "target"=> nickname }
      private = lookup_private(options['target'])
      current_player.buy private, bank, private.par
      next_player!
    end

    def handle_bid(options)
      # options = { 'target' => nickname, 'bid' => value }
      bid = options['bid'].sub(/^\$/, '').to_i
      private = lookup_private(options['target'])
      current_player.bid_on_private private, bid
      next_player!
    end

    # handle any automatic effects
    def handle_effects
      # Handle one effect at a time, let recursion take care of the rest
      if @bank.any_privates_unsold? && @bank.cheapest_private.has_one_bid?
        @bank.cheapest_private.autopurchase(@bank)
      else
        return
      end
      # call until this method does nothing
      handle_effects
    end

    def act(options)
      case options['verb']

      when 'bid_on_private' then handle_bid(options)
      when 'buy_private' then handle_private_purchase(options)
      else raise "No action '#{options['verb']}'"

      end
      handle_effects
    end

    def setup_players(player_ids, options={})
      starting_cash = @implementation.starting_cash(@num_players)
      @players = player_ids.map { |player_id| Player.new(:balance => starting_cash,
                                                         :identifier => player_id) }
      @players.sort!{ rand } unless options[:shuffle_players]
    end

    def setup_privates
      @privates = @implementation.private_companies.collect do |company|
        Private.new(:name => company[:name], :par => company[:par], :revenue => company[:revenue],
                    :special => company[:special], :nickname => company[:nickname])
      end.sort_by { |r| r.par }
    end

    def setup_bank
      @bank = Bank.new(:balance => @implementation.bank_size -
                       (current_player.balance * num_players))
      @privates.each do |private|
        @bank << private
      end
    end

    def go_to_next_player_skipping_checks!
      @players.push @players.shift
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
        list[num]
      else
        false
      end
    end

  end
end
