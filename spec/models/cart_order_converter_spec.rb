require 'rails_helper'

describe CartReservationConverter do
  let(:category) { Category.create!(name: "food")}
  let(:property1) { Property.create!(title: "Test1", description: "For a test", price: 1.5, categories: [category]) }
  let(:property2) { Property.create!(title: "Test2", description: "For testing", price: 1.0, categories: [category]) }
  let(:user) { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password")}
  let(:session_cart) { {property1.id => 2, property2.id => 1} }

  it "takes a session cart and turns it into an reservation" do
    reservation = CartReservationConverter.convert(session_cart, user)
    expect(reservation.properties.count).to eq(3)
    expect(reservation).to be_valid
    expect(reservation.total).to eq(4.0)
  end
end
