require "rails_helper"

# delete the x here to unskip when ready
xdescribe "can add things to the trip", type: :feature do
  context "when logged out" do
    before(:each) do
      # rename these whatever the column names are
      Property.create title: "My Cool Home", description: "cool description",
                      people_it_can_hold: 4, price: 666,
                      bathroom_shared: true
      Property.create title: "Another Home", description: "lame description",
                      people_it_can_hold: 4, price: 666,
                      bathroom_shared: false
      Property.create title: "A Retired Home", description: "retired description",
                      people_it_can_hold: 4, price: 666,
                      bathroom_shared: true, retired: true
      # rails helper method here?
      visit "/listings"
    end

    it "can add things to the trip" do
      # change these to the rails generated helper path methods probably
      visit "/my_trip"
      expect(page).to_not have_content "My Cool Home"
      expect(page).to_not have_content "cool description"
      expect(page).to_not have_content "Another Home"
      expect(page).to_not have_content "lame description"

      visit "/listings"
      click_link_or_button "My Cool Home"
      pending "figure out how dates are filled in"
      # also change "start date" and "end date" to what these actually are
      fill_in "start date", with: ""
      fill_in "end date", with: ""
      click_link_or_button "Add To Trip"

      # does this bring you back to the listing page?
      visit "/listings"
      click_link_or_button "Another Home"
      pending "figure out how dates are filled in"
      # also change "start date" and "end date" to what these actually are
      fill_in "start date", with: ""
      fill_in "end date", with: ""
      click_link_or_button "Add To Trip"

      visit "/my_trip"
      expect(page).to have_content "My Cool Home"
      expect(page).to have_content "cool description"
      expect(page).to have_content "Another Home"
      expect(page).to have_content "lame description"
    end

    it "can remove things from the trip" do
      # change these to the rails generated helper path methods probably
      click_link_or_button "My Cool Home"
      pending "figure out how dates are filled in"
      # also change "start date" and "end date" to what these actually are
      fill_in "start date", with: ""
      fill_in "end date", with: ""
      click_link_or_button "Add To Trip"

      visit "/my_trip"
      expect(page).to have_content "My Cool Home"
      expect(page).to have_content "cool description"
      # might need a within scope, and some renaming
      click_link_or_button "Remove from trip"
      expect(page).to_not have_content "My Cool Home"
      expect(page).to_not have_content "cool description"
    end
  end
end
