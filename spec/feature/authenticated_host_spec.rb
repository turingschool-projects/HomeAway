require 'rails_helper'

context "authenticated host", type: :feature do
  before(:each) do
    host = User.create!(name: "Boy George",
    email_address: "cultureclubforever@eighties.com",
    password: "password",
    password_confirmation: "password",
    host_slug: "boy_george_4evah",
    host: true)
    traveler = User.create!(name: "traveler jim",
    email_address: "traveler@example.com",
    password: "password",
    password_confirmation: "password")
    category = Category.create!(name: "Awesome Place")
    address = Address.create!(line_1: "213 Some St",
    city: "Denver",
    state: "CO",
    zip: "80203")
    property1 = Property.create!(title: "My Cool Home",
    description: "cool description",
    occupancy: 4, price: 666,
    bathroom_private: false,
    category: category,
    address: address,
    user: host)
    property2 = Property.create!(title: "A Retired Home",
    description: "retired description",
    occupancy: 4, price: 666,
    bathroom_private: false, retired: true,
    category: category,
    address: address,
    user: host)
    reservation1 = Reservation.create!(start_date: Date.current.advance(days: 1),
    end_date: Date.current.advance(days: 4), property: property1,
    user: traveler)

    visit root_path
    fill_in "email_address", with: host.email_address
    fill_in "password", with: host.password
    find_button("Login").click
  end

  it "can see my_guests page containing all incoming reservations" do
    visit my_guests_path
    expect(page).to have_content("pending")
    expect(page).to have_content("My Cool Home")
    expect(page).to have_content("traveler jim")
  end

  it "can confirm reservations on my_guests" do
    reservation = Reservation.last
    visit my_guests_path
    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("pending")
      find_button("confirm").click
    end
    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("reserved")
    end
  end

  it "can deny reservations on my_guests" do
    reservation = Reservation.last
    visit my_guests_path

    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("pending")
      find_button("deny").click
    end
    within(".reservation_#{reservation.id}") do
      expect(page).to have_content("denied")
    end
  end
end
