require 'rails_helper'
context 'authenticated host', type: :feature do
  before(:each) do
    host_data = {  name: "Viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password",
                   admin: false,
                   host_slug: "cheeseburgers",
                   host: true }

    host = User.create!(host_data)
    visit root_path
    fill_in "email_address", with: host.email_address
    fill_in "password", with: host.password
    click_button "Login"
  end

  it 'can create property listings' do
    house = Category.create!(name: "House")
    visit new_property_path
    fill_in "property[title]", with: "Burger Shack"
    fill_in "property[description]", with: "Juicy and yummy shack"
    fill_in "property[price]", with: 500
    fill_in "property[occupancy]", with: 7
    select "House", from: "property[category_id]"
    # find("#property_category_ids_#{burgers.id}").set(true)
    fill_in "property[address_attributes][line_1]", with: "123 Main St."
    fill_in "property[address_attributes][city]", with: "Crapsville"
    fill_in "property[address_attributes][state]", with: "CO"
    fill_in "property[address_attributes][zip]", with: 80203
    click_button "Create Property"

    visit properties_path

    expect(Property.last.category).to eq(house)
    expect(Property.last.occupancy).to eq(7)
    expect(page).to have_content("Burger Shack")
  end

  it 'can modify existing properties’ details' do
    house = Category.create!(name: "House")
    address = Address.create!(line_1: "123 Some St.", line_2: "Apt. 6", city: "Denver", state: "CO", zip: "80203")
    property = Property.create!(title: "Burger Shack", description: "Good burger", price: 5000, occupancy: 7, category: house, address: address, user: User.last)
    visit edit_property_path(property)

    fill_in "property[title]", with: "Taco Shack"
    fill_in "property[description]", with: "Really good taco"
    fill_in "property[price]", with: 25

    click_button "Update Property"
    expect(current_path).to eq(properties_path)

    expect(page).to have_content("Taco Shack")
    expect(page).not_to have_content("Burger Shack")
  end

    xit 'can retire an property from being sold' do
    burgers = Category.create!(name: "Burgers")
    property = Property.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])

    visit edit_admin_property_path(property)
    check("Retired")
    find_button("Update Property").click
    expect(property.reload.retired?).to eq(true)
    visit properties_path
    expect(page).to_not have_content(property.title)
  end
end
