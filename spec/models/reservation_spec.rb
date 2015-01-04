require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  let(:category) do
    create(:category,name: "room")
  end

  let(:address) do
    create(:address,line_1: "123 s st", city: "denver", state: "co", zip: "80203")
  end

  let(:user) do
    create(:user,name: "bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")
  end

  let(:start_date) { Date.current }
  let(:end_date) { Date.current.advance(days: 5) }

  it "belongs to a property" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
    expect(reservation.property).to eq(property)
  end

  it "must belong to a user" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(property: property, start_date: start_date, end_date: end_date)
    expect(reservation).to_not be_valid
    reservation = Reservation.new(property: property, user: user, start_date: start_date, end_date: end_date)
    expect(reservation).to be_valid
    expect(reservation.user).to eq user
  end

  it "must have a start and end date" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(property: property, user: user)
    expect(reservation).to_not be_valid

    reservation = Reservation.new(property: property, user: user, start_date: start_date, end_date: end_date)

    expect(reservation).to be_valid
  end

  it "must have a start date greater than or equal to current date" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(property: property, user: user, start_date: Date.yesterday, end_date: end_date)
    expect(reservation).to_not be_valid

    reservation = Reservation.new(property: property, user: user, start_date: Date.current, end_date: end_date)
    expect(reservation).to be_valid
  end

  it "must have an end date greater than the start date" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(property: property, user: user, start_date: end_date, end_date: start_date)
    expect(reservation).to_not be_valid

    reservation = Reservation.new(property: property, user: user, start_date: start_date, end_date: end_date)
    expect(reservation).to be_valid
  end

  it "must have dates that are not already booked" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(property: property, user: user, start_date: start_date, end_date: end_date)
    expect(reservation).to be_valid
    reservation.save

    reservation2 = Reservation.new(property: property, user: user, start_date: start_date.advance(days: 2), end_date: end_date.advance(days: 10))
    expect(reservation2).to_not be_valid
  end

  describe "statuses" do
    it "can generate an array of status names for buttons" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = create(:reservation,user: user, property: property, start_date: start_date, end_date: end_date)

      expect(reservation.state_buttons).to eq(["confirm", "deny"])
    end
    it "should have a default state of pending" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = create(:reservation,user: user, property: property, start_date: start_date, end_date: end_date)
      expect(reservation.status).to eq("pending")
    end

    it "should change status to reserved when confirmed" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
      reservation.confirm!
      expect(reservation.status).to eq("reserved")
    end

    it "changes to cancelled when cancelled" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
      reservation.cancel!
      expect(reservation.status).to eq("cancelled")
    end

    it "can change from pending to cancelled" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
      reservation.cancel!
      expect(reservation.status).to eq("cancelled")
    end

    it "can change from reserved to completed when dates are in past" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
      reservation.confirm!
      expect(reservation.status).to eq("reserved")
      expect { reservation.complete! }.to raise_error
      reservation.update_attribute(:start_date, start_date.advance(days: -10))
      reservation.update_attribute(:end_date, end_date.advance(days: -10))
      reservation.complete
      expect(reservation.status).to eq("completed")
    end

    it "cannot skip states or go backwards" do
      property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
      reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
      expect { reservation.complete! }.to raise_error
      reservation.confirm!
      expect { reservation.confirm! }.to raise_error
      reservation.update_attribute(:start_date, start_date.advance(days: -10))
      reservation.update_attribute(:end_date, end_date.advance(days: -10))
      reservation.complete
      expect(reservation.status).to eq("completed")
    end
  end

  it "can identify an editable reservation" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = Reservation.new(user: user, property: property, start_date: start_date, end_date: end_date)
    expect(reservation.editable?).to eq(true)
    reservation.cancel!
    expect(reservation.editable?).to eq(false)
  end

  it "can calculate a total" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 5.00, address: address, user: user, category: category)
    reservation = create(:reservation,user: user, property: property, start_date: start_date, end_date: end_date)

    expect(reservation.total).to eq 25.to_money
  end

  it "can count duration of a stay" do
    property = create(:property,title: "bob's place", description: "super cozy", price: 500, address: address, user: user, category: category)
    reservation = create(:reservation,user: user, property: property, start_date: start_date, end_date: end_date)

    expect(reservation.duration).to eq 5
  end
end
