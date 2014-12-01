require 'rails_helper'

describe Order do
  let(:category) { Category.create!(name: "food")}
  let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }
  describe "relationships" do
    it "has many items" do
      item = Item.create(title: "title", price: 10, description: "description", categories: [category])
      order = Order.create(user: user, items: [item])
      expect(order.items).to eq([item])
    end

    it "belongs to a user" do
      order = Order.create!(user: user)
      expect(order.user).to eq(user)
    end
  end

  it 'should default status to in_cart' do
    order = Order.create!(address: "address is nice", user: user)
    expect(order.status).to eq("in_cart")
  end

  describe "validations" do
    it "must have a user_id" do
      order = Order.create
      expect(order).to_not be_valid
    end
  end

  describe "delivery or pickup" do
    it "has an address if it's delivery" do
      order = Order.create(user_id: 1, delivery: true, address: nil)
      expect(order).to_not be_valid
    end

    it "is pickup if it's not delivery" do
      order = Order.create(user_id: 1, delivery: false)
      expect(order.pickup?).to eq(true)
    end
  end
end
