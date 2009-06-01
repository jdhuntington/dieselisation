module Dieselisation

  board!
  
  row :a do
    col 3 do
      endpoint :default => 30, :level5 => 60
      connections 3,4
    end
  end
  
  row :b do
    col 2,6,8 do
      initial_cost 60
      mountain
    end
    
    col(4) { :normal }
    
    col 10 do
      endpoint :default => 30, :level5 => 40
      connections 4,5
    end
  end
  
  row :c do
    col(7,9) { :normal }
    
    col 1 do
      initial_cost = 60
      mountain
    end
    
    col(3) { city = "Rome" }
    
    col 5 do
      initial_cost = 20
      river
    end
  end
  
  
  row :d do
    col(2,6,8) { :normal }
    
    col 4 do
      city "Atlanta"
      stations 3
    end
    
    col(10) { city "Augusta" }
    
  end
  
  row :e do
    col(5,9,11) { :normal }
    
    col 1 do
      city "Montgomery"
      stations 0
      endpoint :default => 30, :level5 => 60
      connections 1,2,3
    end
    
    col 3 do
      initial_cost 40
      river
    end
    
    col 7 do
      town "Midgeville"
      initial_cost 20
      river
    end
  end
  
  row :f do
    col(4,10) { :normal }
    
    col 2 do
      river
      initial_cost = 40
    end
    
    col(6) { city "Macon" }
    
    col 8 do
      initial_cost 20
      river
    end
    
    col 12 do
      swamp
      initial_cost 40
    end
  end
  
  row :g do
    col(1,5,7) { :normal }
    
    col 3 do
      river
      city "Columbus"
      initial_cost 40
    end
    
    col 9 do
      river
      initial_cost 20
    end
    
    col(11) { town "Statesboro" }
    
    col(13) { city "Savannah" }
  end
  
  row :h do
    col(6,8) { :normal }
    
    col 2 do
      river
      initial_cost 40
    end
    
    col 4 do
      city "Albany"
    end
    
    col 10,12 do
      river
      initial_cost 20
    end
  end
  
  row :i do
    col(5) { :normal }
    
    col 3 do
      river
      initial_cost 40
    end
    
    col(7){ town "Valdosta" }
    
    col(9) { city "Waycross" }
    col(11) { city "Brunswick" }
  end
  
  row :j do
    col(6,8) { :normal }
    
    col 4 do
      city "Tallahassee"
      stations 0
      endpoint :default => 20, :level5 => 50
      connections 1,2,6
    end
    
    col 10 do
      initial_cost 40
      swamp
    end
    
    col 12 do
      endpoint :default => 30, :level5 => 60
      connections 5,6
      stations 1
    end
  end
end
