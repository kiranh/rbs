class AddIndustryTypeInUser < ActiveRecord::Migration
  def self.up
    add_column :users, :industry_type, :string
  end

  def self.down
    remove_column :users, :industry_type, :string
  end
end
