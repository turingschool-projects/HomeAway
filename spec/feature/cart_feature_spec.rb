require "rails_helper"

describe "can add things to the trip", type: :feature do
  let(:start_date) { 1.year.from_now }
  let(:end_date) { 1.year.from_now.advance(days: 5)}
  context "when logged out" do
    let!(:host) { create(:host) }
    let!(:traveler) { create(:user) }
    let!(:property1) { create(:property, user: host) }
    let!(:property2) { create(:property, user: host) }
    let!(:retired_property) { create(:property, user: host, retired: true) }

    it "can add things to the trip" do
      visit cart_path
      expect(page).to_not have_content property1.title
      expect(page).to_not have_content "cool description"

      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      expect(page).to have_content property1.title
    end

    it "can remove things from the trip" do
      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      expect(page).to have_content property1.title
      click_link_or_button "Cancel My Trip"

      visit cart_path
      expect(page).to_not have_content property1.title
    end

    it "can't make a reservation with invalid dates" do
      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{end_date} - #{start_date}"
      click_link_or_button "Request reservation"
      expect(page).to have_content("Invalid dates")
    end

    it "can't checkout without logging in" do
      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      visit cart_path
      expect(page).to_not have_link "Request Reservation"
      expect(page).to have_content "Log in"
    end

    it "continues checkout after logging in" do
      visit reservations_path
      expect(page).to_not have_content property1.title

      visit properties_path
      click_link_or_button property1.title
      fill_in "property[reservation]", with: "#{start_date} - #{end_date}"
      click_link_or_button "Request reservation"

      login(traveler)
      visit cart_path
      expect(page).to have_content property1.title
      click_link_or_button "Pay"

      visit reservations_path
      expect(page).to have_content property1.title
    end
  end
end
