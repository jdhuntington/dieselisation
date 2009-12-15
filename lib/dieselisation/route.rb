module Dieselisation
  class Route < Base

    def self.optimal game_map, company, trains
      potential_routes = game_map.nodes.select { |n| n.has_company_tokened? company }.map{ |n| new [n], game_map }
      old_potential_routes = []
      while old_potential_routes != potential_routes
        old_potential_routes = potential_routes
        potential_routes = (potential_routes + (potential_routes.map { |route| route.expand_on_endpoints })).flatten.uniq
      end
      
      potential_routes.map { |r| r.value(trains.first) }.max || 0
    end

    include Comparable
    attr_reader :nodes, :game_map

    def initialize(nodes, game_map)
      @nodes = nodes
      @game_map = game_map
    end

    # Ask the map for nodes that connect to this route's endpoints and
    # return all of the routes that extend to those nodes
    def expand_on_endpoints
      nodes_at_the_beginning = (@game_map.connections_to @nodes.first) - @nodes
      nodes_at_the_end = (@game_map.connections_to @nodes.last) - @nodes


      nodes_at_the_beginning.map { |n| self.class.new([n] + @nodes, @game_map) } +\
        nodes_at_the_end.map { |n| self.class.new(@nodes + [n], @game_map) }
    end

    def countable_stops
      @nodes.reject{ |n| n.value.nil? }.length
    end

    def whistle_stops_on_route
      @nodes.select { |n| n.whistle_stop }.count
    end

    def value(train_length)
      return -1 unless train_length >= whistle_stops_on_route
      return 0 unless countable_stops > 1
      @nodes.inject(0){ |sum, current| sum + (current.value || 0) }
    end

    def nicknames
      @nodes.map(&:nickname)
    end

    # Get equality right
    def hash
      [@game_map, @nodes].hash
    end
    
    def eql?(other)
      self == other
    end
    
    def ==(other)
      @game_map == other.game_map && @nodes == other.nodes
    end
  end
end
