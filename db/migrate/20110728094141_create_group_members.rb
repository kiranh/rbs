class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.integer :group_id
      t.integer :member_id
      t.boolean :moderator
      t.string :aasm_state
      t.timestamps
    end
  end
end
