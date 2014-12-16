require "rails_helper"

# delete the x here to unskip when ready
xdescribe "user browsing listings", type: :feature do
  context "when logged out" do
    before(:each) do
      # rename these whatever the column names are
      Property.create title: "My Cool Home", description: "cool description",
                      people_it_can_hold: 4, price: 666,
                      bathroom_shared: true
      Property.create title: "A Retired Home", description: "retired description",
                      people_it_can_hold: 4, price: 666,
                      bathroom_shared: true, retired: true
      # rails helper method here?
      visit "/listings"
    end

    it "shows listings on the listing page" do
      expect(page).to have_content "My Cool Home"
      expect(page).to have_content "cool description"
    end

    it "does not show listings on the listing page when retired" do
      expect(page).to_not have_content "A Retired Home"
      expect(page).to_not have_content "retired description"
    end

    it "has more info on the specific property's page" do
      click_link_or_button "My Cool Home"
      # These are probably going to change a lot depending on the front-end
      expect(page).to_not have_content "Cost $6.66"
      expect(page).to_not have_content "4 people"
    end
  end
end
