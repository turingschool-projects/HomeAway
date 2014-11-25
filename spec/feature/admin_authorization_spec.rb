require 'rails_helper'

context 'authenticated admin', type: :feature do
  before(:each) do
    admin_data = { name: "Viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password",
                   admin: true }
    admin = User.create!(admin_data)
    visit root_path
    fill_in "email_address", with: admin.email_address
    fill_in "password", with: admin.password
    click_button "Login!"
  end

  it 'can create item listings' do
    burgers = Category.create!(name: "Burgers")
    visit new_admin_item_path
    fill_in "Title", with: "Yummiest Burger"
    fill_in "Description", with: "Juicy and yummy burger"
    fill_in "Price", with: 6.5
    find("#item_category_ids_#{burgers.id}").set(true)
    click_button "Create Item"

    expect(current_path).to eq(admin_items_path)
    expect(Item.last.categories).to eq([burgers])
    expect(page).to have_content("Yummiest Burger")
    expect(page).to have_content("Burgers")
  end

  it 'can modify existing items’ name, description, price, and photo' do
    burgers = Category.create!(name: "Burgers")
    burger = Item.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])
    visit edit_admin_item_path(burger)

    fill_in "item_title", with: "Better Burger"
    fill_in "item_description", with: "Really good burger"
    fill_in "item_price", with: 10.0

    click_button "Update Item"
    expect(current_path).to eq(admin_items_path)

    expect(page).to have_content("Better Burger")
    expect(page).not_to have_content("Best Burger")

    expect(page).to have_content("Really good burger")
    expect(page).not_to have_content("Good burger")

    expect(page).to have_content(10.0)
    expect(page).not_to have_content(9.0)
  end

  it 'can create named categories for items (eg: "Small Plates")' do
    visit new_admin_category_path
    fill_in "Name", with: "Appetizers"
    click_button "Create Category"

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Appetizers")
  end

  it 'can assign items to categories or remove them from categories' do
    burgers = Category.create!(name: "Burgers")
    local_game = Category.create!(name: "Local Game")
    item = Item.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])

    visit edit_admin_item_path(item)
    expect(find("#item_category_ids_#{burgers.id}")).to be_checked
    uncheck("Burgers")

    check("Local Game")
    click_button "Update Item"

    expect(current_path).to eq(admin_items_path)
    expect(page).to have_content("Best Burger")
    expect(item.categories.reload).to eq([local_game])
  end

  it 'can retire an item from being sold' do
    burgers = Category.create!(name: "Burgers")
    item = Item.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])

    visit edit_admin_item_path(item)
    check("Retired")
    find_button("Update Item").click
    expect(item.reload.retired?).to eq(true)
    visit items_path
    expect(page).to_not have_content(item.title)
  end
end

context 'unauthenticated admin', type: :feature do
  before(:each) do
    admin_data = { name: "Viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password",
                   admin: false }
    admin = User.create!(admin_data)
    visit root_path
    fill_in "email_address", with: admin.email_address
    fill_in "password", with: admin.password
    click_button "Login!"
  end

  it 'cannot create item listings' do
    visit new_admin_item_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Unauthorized")
  end

  it 'cannot edit existing items' do
    burgers = Category.create!(name: "Burgers")
    burger = Item.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])
    visit edit_admin_item_path(burger)
    expect(current_path).to eq(root_path)

    expect(page).to have_content("Unauthorized")
  end

  it 'cannot create categories' do
    visit new_admin_category_path
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Unauthorized")
  end

  it 'cannot retire an item from being sold' do
    burgers = Category.create!(name: "Burgers")
    item = Item.create!(title: "Best Burger", description: "Good burger", price: 9.0, categories: [burgers])

    visit items_path
    expect(page).not_to have_content("Retire")
  end
end
