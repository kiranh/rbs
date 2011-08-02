class AddDefaultValuesToIndustryTypes < ActiveRecord::Migration
  def change
    IndustryType.create(:name=>"Agriculture")
    IndustryType.create(:name=>"Advertising")
    IndustryType.create(:name=>"Aircraft")
    IndustryType.create(:name=>"Biotechnology")
    IndustryType.create(:name=>"Banking")
    IndustryType.create(:name=>"Computer ")
    IndustryType.create(:name=>"Consumer Products ")
    IndustryType.create(:name=>"Software ")
    IndustryType.create(:name=>"Real Estate")
    IndustryType.create(:name=>"Financial Services")
    IndustryType.create(:name=>"Entertainment & Leisure ")
    IndustryType.create(:name=>"Chemical")
    IndustryType.create(:name=>"Music")
    IndustryType.create(:name=>"Pharmaceuticals")
  end
end

