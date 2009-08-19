module Dieselisation
  class Bank
    def self.instance
      @bank ||= Bank.new
    end
    
    attr_reader :balance, :assets
    
    def initialize(params={ })
      @balance = params[:balance]
      @assets = []
    end
    
    def sell(asset, price)
      deposit(price)
      @assets.delete(asset)
    end
    
    def deposit(deposit)
      @balance += deposit
    end
    
    def withdrawl(withdrawl)
      @balance -= withdrawl
    end
    
    def <<(asset)
      @assets << asset
    end

    def privates
      @assets
    end
    
    def cheapest_private
      !@assets.empty? && @assets.first
    end

    def purchasable_asset?(asset)
      asset == cheapest_private
    end
  end
end
