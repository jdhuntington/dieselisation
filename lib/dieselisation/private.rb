module Dieselisation
  class Private
    attr_reader :name, :par, :revenue, :special, :owner, :bids
    
    def initialize(params={ })
      @name = params[:name]
      @par = params[:par]
      @revenue = params[:revenue]
      @special = params[:special]
      @owner = 'bank'
      @bids = []
    end
    
    def bid(player, price)
      if price >= (highest_bid + 5)
        @bids << {:player => player, :price => price}
      else
        false
      end
    end
    
    def highest_bid
      unless @bids.empty?
        (@bids.map { |b| b[:price] }).sort.last
      else
        # bids must exceed previous bid by at least $5,j or == par
        self.par - 5
      end
    end 
    
    def highest_bidder
      unless @bids.empty?
        (@bids.sort { |a,b| a[:price] <=> b[:price] }).last[:player]
      else
        false
      end
    end 
    
    def bidders
      unless @bids.empty?
        @bids.map { |b| b[:player] }
      else
        []
      end
    end
    
    def clear_bids
      @bids = []
    end
  end
end
