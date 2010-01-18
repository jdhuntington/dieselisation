class AddConfirmedToGameState < ActiveRecord::Migration
  def self.up
    add_column :game_states, :confirmed, :boolean
  end

  def self.down
    remove_column :game_states, :confirmed
  end
end
