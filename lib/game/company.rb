class Company
  attr_reader :name, :president
  
  def initialize(name)
    @name = name
  end

  def shares
    (1..10).collect { |d| d }
  end

  def balance
    0
  end
end
