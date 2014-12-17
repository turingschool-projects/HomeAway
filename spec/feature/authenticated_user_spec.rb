require 'rails_helper'

describe "the authenticated non-administrator", type: :feature do
  let(:user) { User.create!(name: "Boy George",
                email_address: "cultureclubforever@eighties.com",
                password: "password",
                password_confirmation: "password") }

  let(:category) { Category.create!(name: "stuff") }

  let(:item) do
    Item.create!(title: "Greg's Homemade Chili",
    description: "just like mom made it",
    price: 15.50,
    categories: [category])
  end

  before(:each) do
    visit root_path
    fill_in "email address", with: user.email_address
    fill_in "password", with: "password"
    find_button("Login!").click
  end

  it "browses all items" do
    item
    visit items_path
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.description)
  end

  it "can view a single item" do
    item
    visit item_path(item)
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.description)
  end

  it 'browses items by category' do
    item
    visit items_path
    expect(page).to have_link("stuff", :href => "#category-id-#{item.categories.first.id}")
    expect(page).to have_css("span", "category-id-#{item.categories.first.id}")
  end

  it "can add an item to the cart and view the cart" do
    item
    visit items_path
    find_link("Add to Cart").click
    expect(page).to have_content("You have 1 #{item.title}")
    visit cart_items_path
    expect(page).to have_content(item.title)
    expect(page).to have_content("Quantity")
    within(".cart_item_#{item.id} .quantity") do
      expect(page).to have_content("1")
    end
  end

  it 'can remove an item from the cart' do
    item
    visit items_path
    find_link("Add to Cart").click
    visit cart_items_path

    expect(page).to have_content(item.title)
    within(".cart_item_#{item.id} .quantity") do
      expect(page).to have_content("1")
    end

    find_button("Remove").click
    expect(page).to_not have_css(".cart_item_#{item.id}")
    expect(page).to_not have_content(item.title)
  end

  it 'can change the quantity of an item in the cart' do
    item
    visit items_path
    find_link("Add to Cart").click
    visit cart_items_path
    within(".cart_item_#{item.id} .quantity") do
      expect(page).to have_content("1")
    end

    find(:css, ".increase").click
    expect(current_path).to eq(cart_items_path)
    within(".cart_item_#{item.id} .quantity") do
      expect(page).to have_content("2")
    end

    find(:css, ".decrease").click
    within(".cart_item_#{item.id} .quantity") do
      expect(page).to have_content("1")
    end
  end

  it "can logout but not login" do
    visit items_path
    expect(page).to_not have_content("Login!")
    find_link("Logout").click
    expect(page).to_not have_content("Logout")
    expect(page).to have_button("Login!")
  end

  let(:reservation1) { Reservation.create!(user: user, status: "completed") }
  let(:reservation2) { Reservation.create!(user: user, status: "cancelled") }

  before(:each) do
    reservation1.items << item
    reservation2.items << item
  end

  it "can view a list of own past reservations" do
    visit reservations_path
    expect(page).to have_content("completed")
    expect(page).to have_content("cancelled")
  end

  it "can visit an individual past reservation" do
    visit reservations_path
    find(:xpath, "//a[@href='/reservations/#{reservation1.id}']").click
    expect(page).to have_content reservation1.total

    within(".cart_item_#{item.id} .subtotal") do
      expect(page).to have_content("15.5")
    end

    within(".cart_item_#{item.id} .quantity") do
      expect(page).to have_content("1")
    end

    within(".cart_item_#{item.id} .title") do
      expect(page).to have_link("Greg's Homemade Chili")
    end

    expect(page).to have_content("completed")
    expect(page).to have_content reservation1.total
    expect(page).to have_content reservation1.created_at
    expect(page).to have_content reservation1.updated_at
  end

  it "can view retired items from previous reservations but not add them to cart" do
    reservation = Reservation.create!(user: user, status: "paid")
    retired_item = Item.create!(title: "retired", description: "retired", price: 5, categories: [category])
    reservation.items << retired_item
    retired_item.retired = true

    expect(retired_item.retired?).to eq true
    visit reservations_path
    find(:xpath, "//a[@href='/reservations/#{reservation.id}']").click
    within(".cart_item_#{retired_item.id} .title") do
      find_link("retired").click
      expect(page).to_not have_link("Add to Cart")
    end
  end

  it "can view own user info but not other users' info" do
    user2 = User.create!(name: "Bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")

    visit user_path(user)
    expect(page).to have_content(user.name)
    visit user_path(user2)
    expect(current_path).to eq(root_path)
    expect(page).to have_content("You can only view your own")

    visit edit_user_path(user2)
    expect(current_path).to eq(root_path)
    expect(page).to have_content("You can only view your own")
  end

  it "can edit own user info but not other users' info" do
    user2 = User.create!(name: "Bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")

    visit edit_user_path(user)
    fill_in "Email address", with: "boy_george@example.com"
    find_button("Update User").click
    expect(page).to have_content("boy_george@example.com")

    visit edit_user_path(user2)
    expect(current_path).to eq(root_path)
    expect(page).to have_content("You can only view your own")
  end

  it "can view own reservations but not other users' reservations" do
    user2 = User.create!(name: "Bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")
    reservation3 = Reservation.create!(user: user2)
    reservation3.items << item

    visit reservations_path
    expect(page).to have_content(reservation1.status)
    visit reservation_path(reservation1.id)
    expect(page).to have_content(reservation1.total)
    expect(page).to have_content(reservation1.status)

    visit reservation_path(reservation3.id)
    expect(page).to have_content("You may only view your own reservations")
    expect(current_path).to eq(root_path)
  end

  it "can check out" do
    item
    visit items_path
    find_link("Add to Cart").click
    visit cart_items_path
    find_link("Checkout").click
    fill_in "Card number", with: "4242424242424242"
    fill_in "Expiration", with: "10/16"
    find_button("Update Reservation").click
    expect(page).to have_content("Greg's Homemade Chili")
    expect(page).to have_content("reserved")
    visit cart_items_path
    expect(page).to_not have_content("Greg's Homemade Chili")
    expect(page).to have_content("empty")
  end

  it "must put an address to check out a delivery reservation" do
    item
    visit items_path
    find_link("Add to Cart").click
    visit cart_items_path
    find_link("Checkout").click
    check("Delivery?")
    fill_in "Card number", with: "4242424242424242"
    fill_in "Expiration", with: "10/16"
    find_button("Update Reservation").click
    expect(page).to have_content("address: can't be blank")
  end
end
