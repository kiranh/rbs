class Changecolumnusers < ActiveRecord::Migration
  def up
    change_column :users, :friends, :text
  end

  def down
    remove_column :users, :friends
  end
end
