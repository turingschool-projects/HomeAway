require 'rails_helper'

describe ReservationCart do
  let(:category) { Category.create!(name: "food")}
  let(:property1) {Property.create!(title: "Test property", description: "test", price: 1.0, categories: [category]) }
  let(:property2) {Property.create!(title: "Another test property", description: "other test", price: 2.0, categories: [category]) }
  let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }
  let(:reservation) { Reservation.create!(user: user) }
  let!(:reservation_properties) { reservation.reservation_properties.create!([
    {property: property1},
    {property: property1},
    {property: property2}
    ]) }


  subject(:cart) {ReservationCart.new(reservation)}
  it "loads the correct reservation" do
    expect(cart.to_h).to eq({property1.id => 2, property2.id => 1})
  end

  it "can count number of particular property" do
    expect(cart.count_of(property1)).to eq(2)
  end

  it "can count total properties" do
    expect(cart.total_properties).to eq(3)
  end

  it "can calculate total cost" do
    expect(cart.total_cost).to eq(4.0)
  end

  it "can add more properties" do
    cart.add_property(property1)
    expect(cart.total_cost).to eq(5.0)
    expect(cart.total_properties).to eq(4)
  end

  it "can iterate over properties using each" do
    cart.each do |property|
      expect(property.title).to be_present
      expect(property.quantity).to be > 0
    end
  end

  it "can remove an property from the cart" do
    expect(cart.total_properties).to eq 3
    cart.remove_property(property1)
    expect(cart.total_properties).to eq 1
  end

  it "can decrease an property in the cart by one" do
    expect(cart.total_properties).to eq(3)
    expect(cart.subtotal(property1)).to eq(2)
    cart.decrease(property1)
    expect(cart.subtotal(property1)).to eq(1)
    expect(cart.total_properties).to eq(2)
  end

  it "can increase an property in the cart by one" do
    expect(cart.total_properties).to eq(3)
    expect(cart.subtotal(property1)).to eq(2)
    cart.increase(property1)
    expect(cart.subtotal(property1)).to eq(3)
  end

  it "can calculate the subtotal for an property" do
    expect(cart.subtotal(property1)).to eq 2
  end
end
