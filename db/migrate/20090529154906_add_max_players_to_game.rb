class AddMaxPlayersToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :max_players, :integer, :default => 4
  end

  def self.down
    remove_column :games, :max_players
  end
end
