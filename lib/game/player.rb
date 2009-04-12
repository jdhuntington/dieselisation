require File.expand_path(File.join(File.dirname(__FILE__), 'base'))

class Player < Dieselisation::Base
  attr_reader :name
  def initialize(params={ })
    @name = params[:name]
  end
end
