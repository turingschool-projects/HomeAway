require 'rails_helper'

describe CartOrderConverter do
  let(:category) { Category.create!(name: "food")}
  let(:item1) { Item.create!(title: "Test1", description: "For a test", price: 1.5, categories: [category]) }
  let(:item2) { Item.create!(title: "Test2", description: "For testing", price: 1.0, categories: [category]) }
  let(:user) { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password")}
  let(:session_cart) { {item1.id => 2, item2.id => 1} }

  it "takes a session cart and turns it into an order" do
    order = CartOrderConverter.convert(session_cart, user)
    expect(order.items.count).to eq(3)
    expect(order).to be_valid
    expect(order.total).to eq(4.0)
  end
end
