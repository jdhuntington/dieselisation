class Bank
  def self.instance
    @bank ||= Bank.new
  end
end
