require 'rails_helper'

describe 'the unauthenticated user', type: :feature do
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
    occupancy: 4, price: 6.66,
    bathroom_private: false,
    category: Category.last,
    address: Address.last
  end

  it "browses all properties" do
    property = Property.last
    visit properties_path
    expect(page).to have_content(property.title)
    expect(page).to have_content("6.66")
  end

  it "can view a single property" do
    property = Property.last
    visit property_path(property)
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
  end

  xit 'browses properties by category' do
    property = Property.last
    visit properties_path
    expect(page).to have_content("Awesome Place")
  end

  it "can view a property details page" do
    property = Property.last
    visit property_path(property)
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
    expect(page).to have_content(property.location)
    expect(page).to have_content("Booked Dates")
  end
end
