require 'rails_helper'

describe Item do
  let(:category) { Category.create!(name: "nice name") }
  describe "validations" do
    it "validates title presence and uniqueness" do
      item = Item.create(description: "this is the title description", price: 10, categories: [category])
      expect(item).to_not be_valid

      item  = Item.create(title: "title", description: "this is the title description", price: 10, categories: [category])
      item2 = Item.create(title: "title", description: "this is the title description", price: 10, categories: [category])
      expect(item2).to_not be_valid
    end

    it "validates description" do
      item_without_description = Item.create(title: "item title", price: 15, categories: [category])
      expect(item_without_description).to_not be_valid

      item_desc_over_max = Item.create(title: "item title", price: 15, description: "this description is going to be way too long hopefully it's longer than 120 characters asdfjlaksdjflkasjdfkl;adjslkfjadskl;fjlakdsjfkladsjflkdasjflkadsjl;fj", categories: [category])
      expect(item_desc_over_max).to_not be_valid
    end

    it "validates price" do
      item_price_too_low = Item.create(title: "title", price: -1, description: "description", categories: [category])
      expect(item_price_too_low).to_not be_valid
    end
  end

  describe "relationships" do
    let(:item) do
      Item.create!(title: "title", price: 10, description: "description", categories: [category])
    end
    let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }

    it "has many categories" do
      expect(item.categories).to eq([category])
    end

    it "has many orders" do
      order = Order.create(user: user, items: [item])
      expect(item.orders).to eq([order])
    end
  end
end
