module Dieselisation
  class Node < Base
    attr_accessor :whistle_stop, :value, :tokens
    def initialize(params={ })
      @whistle_stop = params[:whistle_stop]
      @value = params[:value]
      @tokens = params[:tokens] || []
    end

    def has_company_tokened? company
      @tokens.include? company
    end
  end
end
