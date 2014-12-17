require 'rails_helper'
describe Category do
  describe "validations" do
    it "validates name" do
      category = Category.create
      expect(category).to_not be_valid

      category  = Category.create(name: "nice name")
      category2 = Category.create(name: "nice name")
      expect(category).to be_valid
      expect(category2).to_not be_valid
    end
  end

  describe "relationships" do
    it "has many properties" do
      category = Category.create(name: "name")
      pending "how are the properties created?"
      property = Property.create!(title: "title", description: "description", price: 1, categories: [category])
      expect(category.properties).to eq([property])
    end
  end
end
