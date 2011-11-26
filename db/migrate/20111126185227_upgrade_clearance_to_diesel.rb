class UpgradeClearanceToDiesel < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.string :encrypted_password, :limit => 128
      t.string :salt, :limit => 128
      t.string :confirmation_token, :limit => 128
      t.string :remember_token, :limit => 128
    end

    remove_column :users, :password

    add_index :users, :email
    add_index :users, :remember_token
  end

  def self.down
    change_table(:users) do |t|
      t.remove :encrypted_password,:salt,:confirmation_token,:remember_token
    end
    add_column :users, :password, :string
  end
end
