require 'rails_helper'

describe Reservation do
  let(:category) { Category.create!(name: "food")}
  let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }
  describe "relationships" do
    it "has many items" do
      item = Item.create(title: "title", price: 10, description: "description", categories: [category])
      reservation = Reservation.create(user: user, items: [item])
      expect(reservation.items).to eq([item])
    end

    it "belongs to a user" do
      reservation = Reservation.create!(user: user)
      expect(reservation.user).to eq(user)
    end
  end

  describe "validations" do
    it "must have a user_id" do
      reservation = Reservation.create
      expect(reservation).to_not be_valid
    end
  end

  describe "delivery or pickup" do
    it "has an address if it's delivery" do
      reservation = Reservation.create(user_id: 1, delivery: true, address: nil)
      expect(reservation).to_not be_valid
    end

    it "is pickup if it's not delivery" do
      reservation = Reservation.create(user_id: 1, delivery: false)
      expect(reservation.pickup?).to eq(true)
    end
  end

  describe "status" do
    it 'should default status to in_cart' do
      reservation = Reservation.create!(user: user)
      expect(reservation.status).to eq("in_cart")
    end

    it "changes to reserved when placed" do
      reservation = Reservation.create!(user: user)
      expect(reservation.status).to eq("in_cart")
      reservation.place!
      expect(reservation.status).to eq("reserved")
    end

    it "cannot be placed with retired items" do
      category = Category.create!(name: "foo things")
      item = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)
      reservation = Reservation.create!(user: user)
      reservation.items << item
      expect { reservation.place }.to raise_error
    end

    it "changes to paid when paid" do
      reservation = Reservation.create!(user: user, status: "reserved")
      reservation.pay!
      expect(reservation.status).to eq("paid")
    end

    it "changes to cancelled when cancelled" do
      reservation = Reservation.create!(user: user, status: "reserved")
      reservation.cancel!
      expect(reservation.status).to eq("cancelled")
    end

    it "can only change from reserved or paid to cancelled" do
      reserved_reservation = Reservation.create!(user: user, status: "reserved")
      paid_reservation = Reservation.create!(user: user, status: "paid")
      completed_reservation = Reservation.create!(user: user, status: "completed")

      reserved_reservation.cancel!
      paid_reservation.cancel!
      expect(reserved_reservation.status).to eq("cancelled")
      expect(paid_reservation.status).to eq("cancelled")

      expect{ completed_reservation.cancel! }.to raise_error
    end

    it "changes to completed when completed" do
      reservation = Reservation.create!(user: user, status: "paid")
      reservation.complete!
      expect(reservation.status).to eq("completed")
    end
  end

  describe "calculations" do
    it "has quantities for each item" do
      item = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)

      reservation = Reservation.create!(user: user, items: [item, item])
      reservation.update_quantities
      expect(reservation.items.first.quantity).to eq 2
    end

    it "has subtotals for each item" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: true)

      reservation = Reservation.create!(user: user)
      reservation.items << item1
      reservation.items << item2
      reservation.items << item2
      reservation.update_quantities
      expect(reservation.subtotal(item1)).to eq 1
      expect(reservation.subtotal(item2)).to eq 4
    end

    it "has a total" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.items << item1
      reservation.items << item2
      reservation.items << item2
      expect(reservation.total).to eq 5
    end

    it "can decrease item quantity" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.items << item1
      reservation.items << item2
      reservation.items << item2
      reservation.update_quantities
      expect(reservation.subtotal(item1)).to eq 1
      expect(reservation.subtotal(item2)).to eq 4
      reservation.decrease(item2)
      expect(reservation.subtotal(item2)).to eq 2
    end

    it "can increase item quantity" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.items << item1
      reservation.items << item2
      reservation.update_quantities
      expect(reservation.subtotal(item1)).to eq 1
      expect(reservation.subtotal(item2)).to eq 2
      reservation.increase(item2)
      expect(reservation.subtotal(item2)).to eq 4
    end

    it "can remove an item" do
      item1 = Item.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      item2 = Item.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.items << item1
      reservation.items << item2
      reservation.update_quantities
      expect(reservation.items.count).to eq 2
      reservation.remove_item(item2)
      expect(reservation.items.count).to eq 1
    end

    it "can identify editable reservations" do
      editable_reservation = Reservation.create!(user: user, status: "paid")
      non_editable_reservation = Reservation.create!(user: user, status: "completed")
      expect(editable_reservation.editable?).to eq true
      expect(non_editable_reservation.editable?).to eq false
    end
  end
end
