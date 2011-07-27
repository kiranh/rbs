class AddBusinessInfocolumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address_line1, :string
    add_column :users, :address_line2, :string
    add_column :users, :state, :string
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :address_line1
    remove_column :users, :address_line2
    remove_column :users, :state
  end
end
