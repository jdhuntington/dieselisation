module Dieselisation
  class Player < Base
    attr_reader :name, :balance, :assets, :seat_order
    
    def initialize(params={ })
      @name = params[:name]
      @balance = params[:balance]
      @assets = []
      @seat_order = params[:seat_order]
    end
    
    def bid_on_private(asset, bid)
      # TODO need to figure out proper error handling
      unless bid >= @balance or bid >= (asset.highest_bid + 5)
        asset.bid(self, bid)
      else
        # raise 'Not enough cash to bid'
        false
      end
    end
    
    def buy(asset, owning_entity, price)
      @balance -= price
      owning_entity.sell(asset, price)
      @assets << asset
    end
  end
end
