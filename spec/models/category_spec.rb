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
      property = Property.create(title: "Log Cabin",
                      price: 44500,
                      description: "guard",
                      category: category,
                      address: Address.create(
                        line_1: "123 Some St.",
                        line_2: "Apt. 6",
                        city: "Denver",
                        state: "CO",
                        zip: "80203"),
                      occupancy: 12)
      expect(category.properties).to eq([property])
    end
  end
end
