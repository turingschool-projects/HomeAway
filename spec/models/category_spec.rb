require 'rails_helper'
describe Category do
  describe "validations" do
    it "validates name" do
      category = build(:category, name: nil)
      expect(category).to_not be_valid

      category  = create(:category,name: "nice name")
      category2 = build(:category,name: "nice name")
      expect(category).to be_valid
      expect(category2).to_not be_valid
    end
  end

  describe "relationships" do
    it "has many properties" do
      category = create(:category,name: "name")
      property = create(:property, category: category)
      expect(category.properties).to include(property)
    end
  end
end
