module Dieselisation
  class Action
    def initialize(type, target)
      @type = type
      @target = target
    end

    def description
      "Buy #{@target.name} ($#{@target.par})"
    end

    def id
      "#{@type}_#{@target.nickname}"
    end

    def type
      @type
    end

    def target
      @target
    end
  end
end
