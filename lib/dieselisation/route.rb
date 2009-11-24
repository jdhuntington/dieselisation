module Dieselisation
  class Route < Base
    def self.optimal map, company
      potential_starting_points = map.nodes.select { |n| n.has_company_tokened? company }
      potential_connections = []
      potential_starting_points.each do |starting_point|
        map.connections_to(starting_point).each do |ending_point|
          potential_connections << [starting_point, ending_point]
        end
      end
      potential_connections.map { |c| new(c) }.map{ |r| r.value }.sort.last || 0
    end

    def initialize(nodes)
      @nodes = nodes
    end

    def countable_stops
      @nodes.reject{ |n| n.value.nil? }.length
    end

    def value
      return 0 unless countable_stops > 1
      @nodes.inject(0){ |sum, current| sum + (current.value || 0) }
    end
  end
end
