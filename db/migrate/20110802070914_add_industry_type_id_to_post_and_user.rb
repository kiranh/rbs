class AddIndustryTypeIdToPostAndUser < ActiveRecord::Migration

  def self.up
    User.all.each{|u| u.destroy}
    Post.all.each{|p| p.destroy}
    remove_column :users, :industry_type
    add_column :users, :industry_type_id, :integer
    add_column :posts, :industry_type_id, :integer
  end

  def self.down
    add_column :users, :industry_type, :string
    remove_column :users, :industry_type_id
    remove_column :posts, :industry_type_id
  end
  
end
