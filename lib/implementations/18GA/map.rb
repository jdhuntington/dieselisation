
#         /\
#   6   /   \  1
#  5   |     |  2
#      |     |
#   4   \   /   3
#        \/

row :a do
  column(3) do |h|
    h.endpoint(:default => 30, :level5 => 60)
    h.connections = [3,4]
  end
end

row :b do
  column([2,6,8]) do |h|
    h.initial_cost = 60
  end

  column 4, :normal

  column(10) do |h|
    h.endpoint(:default => 30, :level5 => 40)
    h.connections = [4,5]
  end
end

row :c do
  column [7,9], :normal
  column 1 do |h|
    h.initial_cost = 60
  end

  column 3 do |h|
    h.city = "Rome"
  end

  column 5 do |h|
    h.initial_cost = 20
    h.river!
  end
end
