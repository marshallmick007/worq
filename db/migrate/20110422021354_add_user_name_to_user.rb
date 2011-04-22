class AddUserNameToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :null => false, :default => ""
    add_index :users, :username, :name => "idx_user_name", :unique => true
  end

  def self.down
    remove_index :users, "idx_user_name"
    remove_column :users, :username
  end
end
