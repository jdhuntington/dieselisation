class Certificate
  attr_reader :company, :shares, :owner
  
  def initialize(company, owner, opts = { })
    opts = { :shares => 1 }.merge(opts)
    @company = company
    @owner = owner
    @shares = opts[:shares]
  end
end
