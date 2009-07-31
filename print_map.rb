game = Dieselisation::GameInstance.new(Dieselisation::Game18GA, [1,2,3,4])

game.board.sorted_rows.each do |row|
  row.each do |cell|
    if cell
      if cell.city?
        putc "c"
      elsif cell.town?
        putc "t"
      elsif cell.mountain?
        putc "^"
      elsif cell.swamp?
        putc "s"
      elsif cell.river?
        putc "r"
      else
        putc "x"
      end

    else
      putc "."
    end
  end
  putc "\n"
end

puts game.board.to_json
