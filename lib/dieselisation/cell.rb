module Dieselisation
  class Cell < Base

    attr_reader :json_data
    
    def initialize
      @json_data = { }
    end

    def endpoint(values)
      @endpoint = true
      @values = values
      @json_data[:endpoint] = 'yes'
      @json_data[:values] = values
    end

    def connections(*connections)
      @connections = connections
      @json_data[:connections] = connections
    end

    def initial_cost(cost)
      @initial_cost = cost
      @json_data[:initial_cost] = cost
    end

    def mountain
      @mountain = true
      @json_data[:mountain] = 'yes'
    end

    def river
      @river = true
      @json_data[:river] = 'yes'
    end

    def city(city_name)
      @city = true
      @city_name = city_name
      @stations = 1
      @json_data[:city] = 'yes'
      @json_data[:city_name] = city_name
      @json_data[:stations] = 1
    end

    def stations(num)
      @stations = num
      @json_data[:stations] = num
    end

    def town(name)
      @town = true
      @town_name = name
      @json_data[:town] = 'yes'
      @json_data[:town_name] = name
    end

    def swamp
      @swamp = true
      @json_data[:swamp] = 'yes'
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

    def to_json
      @json_data.to_json
    end
  end
end
