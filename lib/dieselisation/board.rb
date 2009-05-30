module Dieselisation
  class Board < Base
    attr_reader :rows
    def initialize
      @rows = { }
    end

    def add_row(identifier)
      @rows[identifier] = []
    end

    def add_cell(row, column)
      @rows[row][column] = Cell.new
    end

    def sorted_rows
      @rows.keys.map(&:to_s).sort.map do |key|
        @rows[key.to_sym]
      end
    end

    def normalize!
      @max_length = @rows.values.collect(&:length).inject(0) { |max, current| [max,current].max }
    end
  end
end
