require 'rails_helper'
context 'authenticated host', type: :feature do
  before(:each) do
    address = create(:address, line_1: "123 some St",
                     city: "Denver",
                     state: "CO",
                     zip: "80203")
    host_data = {  name: "Viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password",
                   admin: false,
                   host_slug: "cheeseburgers",
                   address: address,
                   host: true }

    @host = create(:user,host_data)
    visit root_path
    fill_in "email_address", with: @host.email_address
    fill_in "password", with: @host.password
    click_button "Login"
  end

  it 'can create property listings' do
    house = create(:category,name: "House")
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
    property = create(:property, user: @host)
    visit edit_property_path(property)

    fill_in "property[title]", with: "Taco Shack"
    fill_in "property[description]", with: "Really good taco"
    fill_in "property[price]", with: 25

    click_button "Update Property"
    expect(current_path).to eq(user_path(@host))

    expect(page).to have_content("Taco Shack")
    expect(page).not_to have_content("Burger Shack")
  end

  it 'can retire an property from being sold' do
    property = create(:property, user: @host)
    visit edit_property_path(property)
    check("Retired")
    find_button("Update Property").click
    expect(property.reload.retired?).to eq(true)
    visit properties_path
    expect(page).to_not have_content(property.title)
  end
end
