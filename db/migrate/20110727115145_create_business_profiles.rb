class CreateBusinessProfiles < ActiveRecord::Migration
  def self.up
    create_table :business_profiles do |t|
      t.string :user_id
      t.string :name
      t.string :url
      t.string :owner
      t.string :business_type
      t.string :no_of_employees
      t.string :country_id
      t.string :address_line1
      t.string :address_line2
      t.string :state
      t.string :zip
      t.timestamps
    end
    add_index :business_profiles, :user_id
  end

  def self.down
    drop_table :business_profiles
  end
end
