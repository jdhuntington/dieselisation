module Dieselisation
  # Actions
  # characterized by:
  # 
  class Action
    attr_reader :type, :target
    
    def initialize(type, target)
      @type = type
      @target = target
    end

    def description
      "Buy #{@target.type} ($#{@target.par})"
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

    def target_nickname
      target.nickname
    end
  end
end
