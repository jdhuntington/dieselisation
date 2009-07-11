module Dieselisation
  class Action
    attr_reader :name, :target
    
    def initialize(name, target)
      @name = name
      @target = target
    end

    def description
      "Buy #{@target.name} ($#{@target.par})"
    end
  end
end
