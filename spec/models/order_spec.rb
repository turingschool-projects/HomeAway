require 'rails_helper'

describe Reservation do
  let(:category) { Category.create!(name: "food")}
  let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }
  describe "relationships" do
    it "has many properties" do
      property = Property.create(title: "title", price: 10, description: "description", categories: [category])
      reservation = Reservation.create(user: user, properties: [property])
      expect(reservation.properties).to eq([property])
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

    it "cannot be placed with retired properties" do
      category = Category.create!(name: "foo things")
      property = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)
      reservation = Reservation.create!(user: user)
      reservation.properties << property
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
    it "has quantities for each property" do
      property = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)

      reservation = Reservation.create!(user: user, properties: [property, property])
      reservation.update_quantities
      expect(reservation.properties.first.quantity).to eq 2
    end

    it "has subtotals for each property" do
      property1 = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: true)
      property2 = Property.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: true)

      reservation = Reservation.create!(user: user)
      reservation.properties << property1
      reservation.properties << property2
      reservation.properties << property2
      reservation.update_quantities
      expect(reservation.subtotal(property1)).to eq 1
      expect(reservation.subtotal(property2)).to eq 4
    end

    it "has a total" do
      property1 = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      property2 = Property.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.properties << property1
      reservation.properties << property2
      reservation.properties << property2
      expect(reservation.total).to eq 5
    end

    it "can decrease property quantity" do
      property1 = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      property2 = Property.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.properties << property1
      reservation.properties << property2
      reservation.properties << property2
      reservation.update_quantities
      expect(reservation.subtotal(property1)).to eq 1
      expect(reservation.subtotal(property2)).to eq 4
      reservation.decrease(property2)
      expect(reservation.subtotal(property2)).to eq 2
    end

    it "can increase property quantity" do
      property1 = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      property2 = Property.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.properties << property1
      reservation.properties << property2
      reservation.update_quantities
      expect(reservation.subtotal(property1)).to eq 1
      expect(reservation.subtotal(property2)).to eq 2
      reservation.increase(property2)
      expect(reservation.subtotal(property2)).to eq 4
    end

    it "can remove an property" do
      property1 = Property.create!(title: "foo", description: "bar", price: 1, categories: [category], retired: false)
      property2 = Property.create!(title: "foo!", description: "bar", price: 2, categories: [category], retired: false)
      reservation = Reservation.create!(user: user)
      reservation.properties << property1
      reservation.properties << property2
      reservation.update_quantities
      expect(reservation.properties.count).to eq 2
      reservation.remove_property(property2)
      expect(reservation.properties.count).to eq 1
    end

    it "can identify editable reservations" do
      editable_reservation = Reservation.create!(user: user, status: "paid")
      non_editable_reservation = Reservation.create!(user: user, status: "completed")
      expect(editable_reservation.editable?).to eq true
      expect(non_editable_reservation.editable?).to eq false
    end
  end
end
