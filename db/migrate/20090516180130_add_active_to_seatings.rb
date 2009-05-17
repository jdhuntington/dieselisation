class AddActiveToSeatings < ActiveRecord::Migration
  def self.up
    add_column 'seatings', 'active', :boolean
  end

  def self.down
    remove_column 'seatings', 'active'
  end
end
