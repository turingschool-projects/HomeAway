require "rails_helper"

describe "booked trips", type: :feature do
  let!(:user) { create(:user) }
  let!(:property) { create(:property) }
  let!(:reservation) { create(:reservation, user: user, property: property)}

  it "can view a page with reservation details" do
    visit root_path
    login(user)
    visit reservation_path(reservation)
    expect(page).to have_content(reservation.property.title)
    expect(page).to have_content(reservation.duration.floor)
    expect(page).to have_content(reservation.total)
  end

  it "can view a page with upcoming and past reservations" do
    visit root_path
    login(user)
    visit reservations_path

    expect(page).to have_content("Upcoming")
    expect(page).to have_css(".upcoming")
    within(".upcoming") do
      expect(page).to have_content(reservation.property.title)
      expect(page).to have_content(reservation.total)
      expect(page).to have_content(reservation.property.location)
      expect(page).to have_content(reservation.status)
    end

    expect(page).to have_content("Completed")
    expect(page).to_not have_css(".completed")
  end

  it "can view retired properties from previous reservations but not add them to cart" do
    login(user)
    property = create(:property)
    reservation = create(:reservation,user: user, status: "completed", property: property)
    property.retired = true
    property.save!
    expect(property.retired?).to eq true
    visit reservations_path
    find(:xpath, "//a[@href='/reservations/#{reservation.id}']").click
    find_link(property.title).click
    expect(page).to_not have_button("Request reservation")
  end
end
