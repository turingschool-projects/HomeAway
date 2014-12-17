require 'rails_helper'

describe CartReservationConverter do
  let(:category) { Category.create!(name: "food")}
  let(:item1) { Item.create!(title: "Test1", description: "For a test", price: 1.5, categories: [category]) }
  let(:item2) { Item.create!(title: "Test2", description: "For testing", price: 1.0, categories: [category]) }
  let(:user) { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password")}
  let(:session_cart) { {item1.id => 2, item2.id => 1} }

  it "takes a session cart and turns it into an reservation" do
    reservation = CartReservationConverter.convert(session_cart, user)
    expect(reservation.items.count).to eq(3)
    expect(reservation).to be_valid
    expect(reservation.total).to eq(4.0)
  end
end
