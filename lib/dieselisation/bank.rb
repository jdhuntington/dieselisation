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
    
    def cheapest_private
      cheapest = 0
      @assets.each do |a|
        if cheapest == 0
          cheapest = a
        elsif a.par <= cheapest.par
          cheapest = a 
        end
      end
      cheapest
    end
    
  end
end
