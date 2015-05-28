require "rails_helper"

describe "user browsing listings", type: :feature do
  context "when logged out" do
    let!(:property) { create(:property) }
    let!(:retired_property) { create(:property, retired: true) }

    it "browses all properties", js: true do
      6.times { create(:property) }
      visit properties_path
      expect(page).to have_content(Property.first.title.upcase)
      expect(page).not_to have_content(Property.last.title.upcase)
      page.execute_script('window.scrollTo(0,200000)')
      expect(page).to have_content(Property.last.title.upcase)
    end

    it "browses all properties" do
      visit properties_path
      expect(page).to have_content(property.title)
      expect(page).to have_content(property.price)
    end

    it "can view a single property" do
      visit property_path(property)
      expect(page).to have_content(property.title)
      expect(page).to have_content(property.description)
    end

    it "shows listings on the listing page" do
      visit properties_path
      expect(page).to have_content property.title
      expect(page).to have_content property.price
    end

    it "does not show listings on the listing page when retired" do
      visit properties_path
      expect(page).to_not have_content retired_property.title
    end

    it "has more info on the specific property's page" do
      visit properties_path
      click_link_or_button property.title
      expect(page).to have_content property.price
      expect(page).to have_content property.occupancy
    end
  end
end
