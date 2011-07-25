class AddBusinessNameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :business_name, :string
  end

  def self.down
    remove_column :users, :business_name
  end
end
