class Bank
  def self.instance
    @bank ||= Bank.new
  end

  attr_reader :balance

  def init(params)
    @balance = params[:balance]
  end
end
