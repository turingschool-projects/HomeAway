require "rails_helper"

describe "booked trips", type: :feature do
  before(:each) do
    User.create! name: "Viki Harrod",
                 email_address: "viki@example.com",
                 password: "password",
                 password_confirmation: "password"
    Category.create! name: "Awesome Place"
    Address.create! line_1: "213 Some St",
                    city: "Denver",
                    state: "CO",
                    zip: "80203"
    Property.create! title: "My Cool Home", description: "cool description",
                     occupancy: 4, price: 666,
                     bathroom_private: false,
                     category: Category.last,
                     address: Address.last
    Reservation.create! user: User.last,
                        property: Property.last,
                        start_date: Date.current.advance(days: 20),
                        end_date: Date.current.advance(days: 25)
  end
  it "can view a page with reservation details" do
    visit root_path
    find_link("Log In").click
    fill_in "email_address", with: "viki@example.com"
    fill_in "password", with: "password"
    find_button("Login").click
    visit reservation_path(Reservation.last)
    expect(page).to have_content("My Cool Home")
    expect(page).to have_content("5 days")
    expect(page).to have_content("$33.30")
  end

  it "can view a page with upcoming and past reservations" do
    visit root_path
    find_link("Log In").click
    fill_in "email_address", with: "viki@example.com"
    fill_in "password", with: "password"
    find_button("Login").click
    visit reservations_path

    expect(page).to have_content("Upcoming")
    expect(page).to have_css(".upcoming")
    within(".upcoming") do
      expect(page).to have_content("My Cool Home")
      expect(page).to have_content("$33.30")
      expect(page).to have_content("Denver")
      expect(page).to have_content("pending")
    end

    expect(page).to have_content("Completed")
    expect(page).to_not have_css(".completed")
  end
end
