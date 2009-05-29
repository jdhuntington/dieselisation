class AddCommentToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :comment, :text
  end

  def self.down
    remove_column :games, :comment
  end
end
