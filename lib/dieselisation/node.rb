module Dieselisation
  class Node < Base
    attr_accessor :whistle_stop, :value, :tokens, :nickname
    
    def initialize(params={ })
      @whistle_stop = params[:whistle_stop]
      @value = params[:value]
      @tokens = params[:tokens] || []
      @nickname = params[:nickname]
    end

    def has_company_tokened? company
      @tokens.include? company
    end
  end
end
