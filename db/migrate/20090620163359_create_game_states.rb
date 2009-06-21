class CreateGameStates < ActiveRecord::Migration
  def self.up
    create_table :game_states do |t|
      t.integer :game_id
      t.binary :game_state
      t.integer :player_id
      t.timestamps
    end
  end

  def self.down
    drop_table :game_states
  end
end
