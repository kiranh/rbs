class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :logo
      t.boolean :public
      t.timestamps
    end
  end
end
