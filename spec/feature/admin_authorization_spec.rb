require 'rails_helper'
# another skip line 128
context 'authenticated admin', type: :feature do
  before(:each) do
    admin = FactoryGirl.create( :host,
                                display_name: "Horace",
                                name: "Horace Williams",
                                email_address: "demo+horace@jumpstartlab.com",
                                host_slug: nil,
                                admin: true)
    visit root_path
    fill_in "email_address", with: admin.email_address
    fill_in "password", with: admin.password
    click_button "Login"
  end

  it 'cannot create property listings without valid attributes' do
    visit new_property_path
    fill_in "Price", with: 0
    click_button "Create Property"
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Price must be greater than 0")
  end

  it 'can modify existing properties’ name, description, price, and photo' do
    burgers = create(:category,name: "burgers")
    burger = create(:property,title: "best burger", description: "good burger", price: 9.0, category: burgers)
    visit edit_property_path(burger)

    fill_in "property_title", with: "Better Burger"
    fill_in "property_description", with: "Really good burger"
    fill_in "property_price", with: 10.0

    click_button "Update Property"
    visit property_path(burger)

    expect(page).to have_content("Better Burger")
    expect(page).not_to have_content("Best Burger")

    expect(page).to have_content("Really good burger")
    expect(page).not_to have_content("Good burger")

    expect(page).to have_content(10.0)
    expect(page).not_to have_content(9.0)
  end

  it 'cannot update property listings to have invalid attributes' do
    burgers = create(:category,name: "burgers")
    property = create(:property,
                        title: "Yummiest Burger",
                        description: "Juicy and yummy burger",
                        price: 5.0,
                        category: burgers
                        )

    visit edit_property_path(property)
    fill_in "Title", with: ""
    fill_in "Description", with: ""
    fill_in "Price", with: 0
    click_button "Update Property"
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Price must be greater than 0")
  end

  it 'can create named categories for properties (eg: "Small Plates")' do
    visit new_admin_category_path
    fill_in "Name", with: "Appetizers"
    click_button "Create Category"

    visit(admin_categories_path)
    expect(page).to have_content("Appetizers")
  end

  it 'cannot create categories without a name' do
    visit new_admin_category_path
    click_button "Create Category"
    expect(page).to have_content("Name can't be blank")
  end

  it 'can assign properties to categories or remove them from categories' do
    burgers = create(:category,name: "burgers")
    local_game = create(:category,name: "local game")
    property = create(:property,title: "best burger", description: "good burger", price: 9.0, category: burgers)

    visit edit_property_path(property)
    select 'local game', from: 'property[category_id]'
    click_button "Update Property"

    visit property_path(property)
    expect(page).to_not have_content("burgers")
    expect(page).to have_content("local game")
  end

  it 'can retire an property from being sold' do
    burgers = create(:category,name: "burgers")
    property = create(:property,title: "best burger", description: "good burger", price: 9.0, category: burgers)

    visit edit_property_path(property)
    check("Retired")
    find_button("Update Property").click
    expect(property.reload.retired?).to eq(true)
    visit properties_path
    expect(page).to_not have_content(property.title)
  end
end

xcontext 'authenticated non-admin', type: :feature do
  before(:each) do
    admin_data = { name: "Viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password",
                   admin: false }
    admin = create(:user,admin_data)
    visit root_path
    fill_in "email_address", with: admin.email_address
    fill_in "password", with: admin.password
    click_button "Login!"
  end

  it 'cannot create property listings' do
    visit new_admin_property_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Unauthorized")
  end

  it 'cannot edit existing properties' do
    burgers = create(:category,name: "burgers")
    burger = create(:property,title: "best burger", description: "good burger", price: 9.0, categories: [burgers])
    visit edit_admin_property_path(burger)
    expect(current_path).to eq(root_path)

    expect(page).to have_content("Unauthorized")
  end

  it 'cannot create categories' do
    visit new_admin_category_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Unauthorized")
  end

  it 'cannot retire an property from being sold' do
    burgers = create(:category,name: "burgers")
    property = create(:property,title: "best burger", description: "good burger", price: 9.0, categories: [burgers])

    visit properties_path
    expect(page).not_to have_content("Retire")
  end
end
