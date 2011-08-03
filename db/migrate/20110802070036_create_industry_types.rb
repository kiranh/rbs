class CreateIndustryTypes < ActiveRecord::Migration
   def self.up
    create_table :industry_types do |t|
      t.string :name
      t.timestamps
    end
  end
  def self.down
    drop_table "industry_types"
  end
end
