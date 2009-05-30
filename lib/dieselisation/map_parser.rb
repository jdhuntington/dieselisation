module Dieselisation

  def self.board!
    @board = Board.new
  end

  def self.get_board
    @board
  end
  
  def self.row(row_name)
    @current_row = row_name
    @board.add_row(row_name)
    yield
  end

  def self.col(*column_numbers)
    column_numbers.each do |column_number|
      @current_column = column_number
      @current_cell = @board.add_cell(@current_row, @current_column)
      val = yield
    end
  end

  class << self
    [ :city, :town, :swamp, :stations, :river, :mountain, :endpoint, :connections, :initial_cost ].each do |cell_method|
      define_method(cell_method) { |*args| @current_cell.send(cell_method, *args) }
    end
  end


end
