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

  describe "status" do
    it 'should default status to in_cart' do
      order = Order.create!(user: user)
      expect(order.status).to eq("in_cart")
    end

    it "changes to ordered when placed" do
      order = Order.create!(user: user)
      expect(order.status).to eq("in_cart")
      order.place!
      expect(order.status).to eq("ordered")
    end

    it "cannot be placed with retired items" do
      category = Category.create!(name: "foo things")
      item = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)
      order = Order.create!(user: user)
      order.items << item
      expect { order.place }.to raise_error
    end

    it "changes to paid when paid" do
      order = Order.create!(user: user, status: "ordered")
      order.pay!
      expect(order.status).to eq("paid")
    end

    it "changes to cancelled when cancelled" do
      order = Order.create!(user: user, status: "ordered")
      order.cancel!
      expect(order.status).to eq("cancelled")
    end

    it "can only change from ordered or paid to cancelled" do
      ordered_order = Order.create!(user: user, status: "ordered")
      paid_order = Order.create!(user: user, status: "paid")
      completed_order = Order.create!(user: user, status: "completed")

      ordered_order.cancel!
      paid_order.cancel!
      expect(ordered_order.status).to eq("cancelled")
      expect(paid_order.status).to eq("cancelled")

      expect{ completed_order.cancel! }.to raise_error
    end

    it "changes to completed when completed" do
      order = Order.create!(user: user, status: "paid")
      order.complete!
      expect(order.status).to eq("completed")
    end
  end

  describe "calculations" do
    it "has quantities for each item" do
      item = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)

      order = Order.create!(user: user, items: [item, item])
      order.update_quantities
      expect(order.items.first.quantity).to eq 2
    end

    it "has subtotals for each item" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: true)

      order = Order.create!(user: user)
      order.items << item1
      order.items << item2
      order.items << item2
      order.update_quantities
      expect(order.subtotal(item1)).to eq 1
      expect(order.subtotal(item2)).to eq 4
    end

    it "has a total" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      order = Order.create!(user: user)
      order.items << item1
      order.items << item2
      order.items << item2
      expect(order.total).to eq 5
    end

    it "can decrease item quantity" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      order = Order.create!(user: user)
      order.items << item1
      order.items << item2
      order.items << item2
      order.update_quantities
      expect(order.subtotal(item1)).to eq 1
      expect(order.subtotal(item2)).to eq 4
      order.decrease(item2)
      expect(order.subtotal(item2)).to eq 2
    end

    it "can increase item quantity" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      order = Order.create!(user: user)
      order.items << item1
      order.items << item2
      order.update_quantities
      expect(order.subtotal(item1)).to eq 1
      expect(order.subtotal(item2)).to eq 2
      order.increase(item2)
      expect(order.subtotal(item2)).to eq 4
    end

    it "can remove an item" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      order = Order.create!(user: user)
      order.items << item1
      order.items << item2
      order.update_quantities
      expect(order.items.count).to eq 2
      order.remove_item(item2)
      expect(order.items.count).to eq 1
    end

    it "can identify editable orders" do
      editable_order = Order.create!(user: user, status: "paid")
      non_editable_order = Order.create!(user: user, status: "completed")
      expect(editable_order.editable?).to eq true
      expect(non_editable_order.editable?).to eq false
    end
  end
end
