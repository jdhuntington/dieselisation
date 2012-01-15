module Dieselisation
  class Player < Base
    attr_reader :name, :balance, :assets, :bids, :identifier
    
    def initialize(params={ })
      @name = params[:name]
      @balance = params[:balance]
      @assets = []
      @identifier = params[:identifier]
      @bids = {}
    end
    
    def bid_on_private(asset, bid)
      if bid <= available_balance && bid >= (asset.minimum_bid)
        @bids[asset.name] = bid
        asset.bid(self, bid)
      else
        params = { :bid => bid,
          :available_balance => available_balance,
          :minimum_bid => asset.minimum_bid }
        raise InvalidBid.new("Can't bid #{bid} on #{asset.nickname}. #{params.inspect}")
      end
    end
    
    def pass(asset)
      asset.pass(self)
    end
    
    def buy(asset, owning_entity, price)
      @balance -= price
      owning_entity.sell(asset, price)
      @assets << asset
      asset.owner = self
    end

    def available_balance
      @balance - bids_total
    end
    
    def bids_total
      total = 0
      @bids.each do |k,v|
        total += v
      end
      total
    end
    
    def clear_bids(asset)
      @bids.delete(asset.name) if @bids.has_key?(asset.name)
    end

    def to_json
      { :identifier => @identifier,
       :balance => @balance,
       :assets => @assets
       }.to_json
    end
    
  end
end
