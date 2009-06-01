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

    def sorted_row_names
      @rows.keys.map(&:to_s).sort
    end
    
    def sorted_rows
      @rows.keys.map(&:to_s).sort.map do |key|
        @rows[key.to_sym]
      end
    end

    def normalize!
      @max_length = @rows.values.collect(&:length).inject(0) { |max, current| [max,current].max }
    end

    def width
      @max_length
    end
    
    def height
      @rows.keys.length
    end

    def to_json
      cells = { }
      @rows.keys.each do |row_name|
        row = @rows[row_name]
        row.each_with_index do |cell, index|
          next unless cell
          cells["cell_#{row_name}_#{index}"] = cell.json_data
        end
      end
      { :rows => sorted_row_names, :columns => width, :cells => cells}.to_json
    end
  end
end
