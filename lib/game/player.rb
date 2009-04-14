require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

class Player < Dieselisation::Base
  attr_reader :name, :balance
  def initialize(params={ })
    @name = params[:name]
    @balance = params[:balance]
  end
end
