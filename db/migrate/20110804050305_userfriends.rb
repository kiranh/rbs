class Userfriends < ActiveRecord::Migration
  def up
    add_column :users, :friends, :string
  end

  def down
    drop_column :users, :friends
  end
end
