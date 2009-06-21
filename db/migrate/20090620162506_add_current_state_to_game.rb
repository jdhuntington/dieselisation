class AddCurrentStateToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :game_state_id, :integer
  end

  def self.down
    remove_column :games, :game_state_id
  end
end
