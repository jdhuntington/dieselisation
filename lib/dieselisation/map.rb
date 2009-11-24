module Dieselisation
  class Map < Base
    attr_accessor :nodes, :connections
    def initialize(params={ })
      @nodes = params[:nodes] || []
      @connections = params[:connections] || []
    end

    def connections_to(node)
      found_connections = []
      @connections.each do |connection|
        found_connections << connection if connection.include? node
      end
      found_connections.flatten.uniq - [node]
    end
  end
end
