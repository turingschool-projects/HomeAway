require "rails_helper"

describe "user browsing listings", type: :feature do
  context "when logged out" do
    let!(:property1) do
      create :property, title: "My Cool Home", description: "cool description",
      occupancy: 4, price: 6.66,
      bathroom_private: false
    end
    let!(:property2) do
      create :property, title: "A Retired Home", description: "retired description",
      occupancy: 4, price: 6.66,
      bathroom_private: false, retired: true
    end

    it "shows listings on the listing page" do
      visit properties_path
      expect(page).to have_content "My Cool Home"
      expect(page).to have_content "6.66"
    end

    it "does not show listings on the listing page when retired" do
      visit properties_path
      expect(page).to_not have_content "A Retired Home"
      expect(page).to_not have_content "retired description"
    end

    it "has more info on the specific property's page" do
      visit properties_path
      click_link_or_button "My Cool Home"
      expect(page).to have_content "$6.66"
      expect(page).to have_content "4"
    end
  end
end
