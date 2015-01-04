require 'rails_helper'

describe 'the unauthenticated user', type: :feature do
  let!(:user) { create(:user) }
  let!(:property) { create(:property) }

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

  it "can view a property details page" do
    visit property_path(property)
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
    expect(page).to have_content(property.location)
    expect(page).to have_content("Booked Dates")
  end
end
