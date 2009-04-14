class Bank
  def self.instance
    @bank ||= Bank.new
  end

  attr_reader :balance, :assets

  def init(params)
    @balance = params[:balance]
    @assets = []
  end

  def <<(asset)
    @assets << asset
  end
end
