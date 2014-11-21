require 'rails_helper'

describe Item do
  it { should have_attribute(:title) }
  it { should have_attribute(:description) }
  it { should have_attribute(:price) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it { should validate_uniqueness_of(:title) }

  it { should validate_numericality_of(:price).
    is_greater_than(0) }

  it { should have_many(:item_categories) }
  it { should have_many(:categories) }

  it { should have_many(:orders)}

  describe "validations" do
    it "validates title" do
      item = Item.create(description: "this is the title description", price: 10)
      expect(item.id).to be_nil
    end

    it "validates description" do
      item_without_description = Item.create(title: "item title", price: 15)
      expect(item_without_description.id).to be_nil

      item_desc_over_max = Item.create(title: "item title", price: 15, description: "this description is going to be way too long hopefully it's longer than 120 characters asdfjlaksdjflkasjdfkl;adjslkfjadskl;fjlakdsjfkladsjflkdasjflkadsjl;fj")
      expect(item_desc_over_max.id).to be_nil
    end

    it "validates price" do
      item_price_too_low = Item.create(title: "title", price: -1, description: "description")
      expect(item_price_too_low.id).to be_nil
    end
  end

  describe "relationships" do
    let(:item) do
      Item.create(title: "title", price: 10, description: "description")
    end

    it "has many categories" do
      category = Category.create(name: "Burger")
      ItemCategory.create(item_id: item.id, category_id: category.id)
      expect(item.categories.first).to eq(category)
    end

    it "has many orders" do
      order = Order.create
      OrderItem.create(order_id: order.id, item_id: item.id)
      expect(item.orders.first).to eq(order)
    end
  end
end
