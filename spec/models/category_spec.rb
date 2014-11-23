require 'rails_helper'

describe Category do
  # it { should have_attribute(:name) }

  # it { should validate_presence_of(:name) }
  # it { should validate_uniqueness_of(:name) }

  # it { should have_many(:item_categories) }
  # it { should have_many(:items).through :item_categories }

  describe "validations" do
    it "validates name" do
      category = Category.create
      expect(category.id).to be_nil

      category  = Category.create(name: "nice name")
      category2 = Category.create(name: "nice name")
      expect(category2.id).to be_nil
    end
  end

  describe "relationships" do
    it "has many items" do
      category = Category.create(name: "name")
      item = Item.create(title: "title", description: "description", price: 1)
      ItemCategory.create(item_id: item.id, category_id: category.id )
      expect(category.items.first).to eq(item)
    end
  end







end

