module Dieselisation
  class Private
    attr_accessor :name, :par, :revenue, :special, :owner, :bids

    def initialize(params={ })
      @name = params[:name]
      @par = params[:par]
      @revenue = params[:revenue]
      @special = params[:special]
      @owner = 'bank'
      @bids = []
      @nickname = params[:nickname]
    end

    def to_json
      {
        :name => @name,
        :par => @par,
        :revenue => @revenue,
        :special => @special,
        :owner => @owner,
        :bids => @bids
      }.to_json
    end

    def nickname
      @nickname
    end

    def bid(player, price)
      if price >= minimum_bid
        @bids << {:player => player, :price => price}
      else
        raise InvalidBid.new("Can't bid that")
      end
    end

    def has_one_bid?
      @bids.length == 1
    end

    # used when there is one bid on self
    def autopurchase(from)
      raise "Can't autopurchase me!" unless self.has_one_bid?
      bid = @bids.first
      bid[:player].buy(self, from, bid[:price])
      clear_bids
      true
    end

    def minimum_bid
      if @bids.empty?
        self.par + 5 # TODO make sure this is actually the rule
      else
        (@bids.map { |b| b[:price] }).sort.last + 5
      end
    end

    def highest_bid
      if @bids.empty?
        nil
      else
        (@bids.map { |b| b[:price] }).sort.last
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
