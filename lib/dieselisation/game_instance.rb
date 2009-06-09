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
    
    # this is very 18GA specific
    def player_options
      options = {}
      if @current_round == SR
        if (@bank.assets.map { |a| a.class == Dieselisation::Private }).include?(true)
          options[:buy_private] = {:private => @bank.cheapest_private}
          # options[:bid_on_private] = 
        end
        
      elsif @current_round == OR
        
      else
        raise 'Unknown round.'
      end
      
      return options
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
      players.each do |id, player|
        seat = order.shift
        @players["id#{seat}"] = Player.new({:name => player[:name], :balance => starting_cash,
                                   :seat_order => seat})
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
