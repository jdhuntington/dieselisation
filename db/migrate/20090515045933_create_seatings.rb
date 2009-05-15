class CreateSeatings < ActiveRecord::Migration
  def self.up
    create_table 'seatings' do |t|
      t.integer 'position'
      t.integer 'user_id'
      t.integer 'game_id'
      t.timestamps
    end
  end

  def self.down
    drop_table 'seatings'
  end
end
