require 'rails_helper'

describe OrderCart do
  let(:category) { Category.create!(name: "food")}
  let(:item1) {Item.create!(title: "Test item", description: "test", price: 1.0, categories: [category]) }
  let(:item2) {Item.create!(title: "Another test item", description: "other test", price: 2.0, categories: [category]) }
  let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }
  let(:order) { Order.create!(user: user) }
  let!(:order_items) { order.order_items.create!([
    {item: item1},
    {item: item1},
    {item: item2}
    ]) }


  subject(:cart) {OrderCart.new(order)}
  it "loads the correct order" do
    expect(cart.to_h).to eq({item1.id => 2, item2.id => 1})
  end

  it "can count number of particular item" do
    expect(cart.count_of(item1)).to eq(2)
  end

  it "can count total items" do
    expect(cart.total_items).to eq(3)
  end

  it "can calculate total cost" do
    expect(cart.total_cost).to eq(4.0)
  end

  it "can add more items" do
    cart.add_item(item1)
    expect(cart.total_cost).to eq(5.0)
    expect(cart.total_items).to eq(4)
  end

  it "can iterate over items using each" do
    cart.each do |item|
      expect(item.title).to be_present
      expect(item.quantity).to be > 0
    end
  end

  it "can remove an item from the cart" do
    expect(cart.total_items).to eq 3
    cart.remove_item(item1)
    expect(cart.total_items).to eq 1
  end

  it "can decrease an item in the cart by one" do
    expect(cart.total_items).to eq(3)
    expect(cart.subtotal(item1)).to eq(2)
    cart.decrease(item1)
    expect(cart.subtotal(item1)).to eq(1)
    expect(cart.total_items).to eq(2)
  end

  it "can increase an item in the cart by one" do
    expect(cart.total_items).to eq(3)
    expect(cart.subtotal(item1)).to eq(2)
    cart.increase(item1)
    expect(cart.subtotal(item1)).to eq(3)
  end

  it "can calculate the subtotal for an item" do
    expect(cart.subtotal(item1)).to eq 2
  end
end
