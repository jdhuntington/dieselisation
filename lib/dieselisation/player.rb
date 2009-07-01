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
        # puts (@balance - bids_total)
      if bid <= (@balance - bids_total)
        # puts asset.highest_bid + 5
        if bid >= (asset.highest_bid + 5)
          @bids[asset.name] = bid
          asset.bid(self, bid)
        else
          false
        end
      else
        false
      end
    end
    
    def buy(asset, owning_entity, price)
      @balance -= price
      owning_entity.sell(asset, price)
      @assets << asset
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
