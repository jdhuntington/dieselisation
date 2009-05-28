class AddOwnerToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :owner_id, :integer
  end

  def self.down
    remove_column :games, :owner_id
  end
end
