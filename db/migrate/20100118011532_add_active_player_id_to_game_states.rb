class AddActivePlayerIdToGameStates < ActiveRecord::Migration
  def self.up
    add_column :game_states, :active_player_id, :integer
  end

  def self.down
    remove_column :game_states, :active_player_id
  end
end
