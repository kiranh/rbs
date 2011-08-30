class CreateShortMessages < ActiveRecord::Migration
  def up
    create_table :short_messages do |t|
      t.string :message
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table "short_messages"
  end
end
