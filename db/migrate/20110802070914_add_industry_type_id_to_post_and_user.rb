class AddIndustryTypeIdToPostAndUser < ActiveRecord::Migration

  def self.up
    remove_column :users, :industry_type
    add_column :users, :industry_type_id, :integer
    add_column :posts, :industry_type_id, :integer
    User.reset_column_information
    Post.reset_column_information
    User.all.each do |u|
      u.update_attribute("industry_type_id", 5)
      u.save!
    end
    Post.all.each do |p|
      p.update_attribute("industry_type_id", 5)
      p.save!
    end
  end

  def self.down
    add_column :users, :industry_type, :string
    remove_column :users, :industry_type_id
    remove_column :posts, :industry_type_id
  end
  
end



