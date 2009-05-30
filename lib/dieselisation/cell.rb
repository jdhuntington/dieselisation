module Dieselisation
  class Cell < Base
    def initialize
    end

    def endpoint(values)
      @endpoint = true
      @values = values
    end

    def connections(*connections)
      @connections = connections
    end

    def initial_cost(cost)
      @initial_cost = cost
    end

    def mountain
      @mountain = true
    end

    def river
      @river = true
    end

    def city(city_name)
      @city = true
      @city_name = city_name
      @stations = 1
    end

    def stations(num)
      @stations = num
    end

    def town(name)
      @town = true
      @town_name = name
    end

    def swamp
      @swamp = true
    end

    def mountain?
      @mountain
    end
    
    def river?
      @river
    end
    
    def city?
      @city
    end
    
    def town?
      @town
    end
    
    def swamp?
      @swamp
    end
    

  end
end
