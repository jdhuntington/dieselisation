require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

class Player < Dieselisation::Base
  attr_reader :name, :balance, :assets
  
  def initialize(params={ })
    @name = params[:name]
    @balance = params[:balance]
    @assets = []
  end

  def buy(asset, owning_entity, price)
    @balance -= price
    owning_entity.sell(asset, price)
    @assets << asset
  end
end
