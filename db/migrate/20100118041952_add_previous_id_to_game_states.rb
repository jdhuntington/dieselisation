class AddPreviousIdToGameStates < ActiveRecord::Migration
  def self.up
    add_column :game_states, :previous_id, :integer
  end

  def self.down
    remove_column :game_states, :previous_id
  end
end
