class AddEmailNotificationOptionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :email_notification, :boolean
  end

  def self.down
    remove_column :users, :email_notification
  end
end
