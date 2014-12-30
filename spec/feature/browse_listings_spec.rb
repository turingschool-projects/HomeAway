require "rails_helper"

describe "user browsing listings", type: :feature do
  context "when logged out" do
    before(:each) do
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
      Property.create! title: "A Retired Home", description: "retired description",
                      occupancy: 4, price: 666,
                      bathroom_private: false, retired: true,
                      category: Category.last,
                      address: Address.last
      visit properties_path
    end

    it "shows listings on the listing page" do
      expect(page).to have_content "My Cool Home"
      expect(page).to have_content "6.66"
    end

    it "does not show listings on the listing page when retired" do
      expect(page).to_not have_content "A Retired Home"
      expect(page).to_not have_content "retired description"
    end

    it "has more info on the specific property's page" do
      click_link_or_button "My Cool Home"
      expect(page).to have_content "$6.66"
      expect(page).to have_content "4"
    end
  end
end
