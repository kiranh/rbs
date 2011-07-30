class Addgroupcolumntoposts < ActiveRecord::Migration
  def up
    add_column :posts, :group_id, :integer
  end

  def down
    remove_column :posts, :group_id
  end
end
