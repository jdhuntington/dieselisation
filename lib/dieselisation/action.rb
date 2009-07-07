module Dieselisation
  class Action
    def initialize(type, target)
      @type = type
      @target = target
    end

    def description
      "Buy #{@target.name} ($#{@target.par})"
    end
  end
end
