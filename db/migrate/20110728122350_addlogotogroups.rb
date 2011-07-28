class Addlogotogroups < ActiveRecord::Migration
  def up
    add_column :groups, :logo_id, :integer
  end

  def down
    remove_column :groups, :logo_id
  end
end
