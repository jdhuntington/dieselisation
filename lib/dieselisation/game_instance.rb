require File.expand_path(File.dirname(__FILE__) + '/map_parser')

module Dieselisation
  class GameInstance < Base
    def initialize(implementation)
      @implementation = implementation
      parse_map!
    end
    
    def board
      @board
    end

    protected
    def parse_map!
      require @implementation::MAPFILE
      @board = ::Dieselisation.get_board
      @board.normalize!
    end
  end
end
