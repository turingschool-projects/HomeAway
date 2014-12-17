require 'rails_helper'

describe "the authenticated non-administrator", type: :feature do
  let(:user) { User.create!(name: "Boy George",
                email_address: "cultureclubforever@eighties.com",
                password: "password",
                password_confirmation: "password") }

  let(:category) { Category.create!(name: "stuff") }

  let(:property) do
    Property.create!(title: "Greg's Homemade Chili",
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

  it "browses all properties" do
    property
    visit properties_path
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
  end

  it "can view a single property" do
    property
    visit property_path(property)
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
  end

  it 'browses properties by category' do
    property
    visit properties_path
    expect(page).to have_link("stuff", :href => "#category-id-#{property.categories.first.id}")
    expect(page).to have_css("span", "category-id-#{property.categories.first.id}")
  end

  it "can add an property to the cart and view the cart" do
    property
    visit properties_path
    find_link("Add to Cart").click
    expect(page).to have_content("You have 1 #{property.title}")
    visit cart_properties_path
    expect(page).to have_content(property.title)
    expect(page).to have_content("Quantity")
    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("1")
    end
  end

  it 'can remove an property from the cart' do
    property
    visit properties_path
    find_link("Add to Cart").click
    visit cart_properties_path

    expect(page).to have_content(property.title)
    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("1")
    end

    find_button("Remove").click
    expect(page).to_not have_css(".cart_property_#{property.id}")
    expect(page).to_not have_content(property.title)
  end

  it 'can change the quantity of an property in the cart' do
    property
    visit properties_path
    find_link("Add to Cart").click
    visit cart_properties_path
    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("1")
    end

    find(:css, ".increase").click
    expect(current_path).to eq(cart_properties_path)
    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("2")
    end

    find(:css, ".decrease").click
    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("1")
    end
  end

  it "can logout but not login" do
    visit properties_path
    expect(page).to_not have_content("Login!")
    find_link("Logout").click
    expect(page).to_not have_content("Logout")
    expect(page).to have_button("Login!")
  end

  let(:reservation1) { Reservation.create!(user: user, status: "completed") }
  let(:reservation2) { Reservation.create!(user: user, status: "cancelled") }

  before(:each) do
    reservation1.properties << property
    reservation2.properties << property
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

    within(".cart_property_#{property.id} .subtotal") do
      expect(page).to have_content("15.5")
    end

    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("1")
    end

    within(".cart_property_#{property.id} .title") do
      expect(page).to have_link("Greg's Homemade Chili")
    end

    expect(page).to have_content("completed")
    expect(page).to have_content reservation1.total
    expect(page).to have_content reservation1.created_at
    expect(page).to have_content reservation1.updated_at
  end

  it "can view retired properties from previous reservations but not add them to cart" do
    reservation = Reservation.create!(user: user, status: "paid")
    retired_property = Property.create!(title: "retired", description: "retired", price: 5, categories: [category])
    reservation.properties << retired_property
    retired_property.retired = true

    expect(retired_property.retired?).to eq true
    visit reservations_path
    find(:xpath, "//a[@href='/reservations/#{reservation.id}']").click
    within(".cart_property_#{retired_property.id} .title") do
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
    reservation3.properties << property

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
    property
    visit properties_path
    find_link("Add to Cart").click
    visit cart_properties_path
    find_link("Checkout").click
    fill_in "Card number", with: "4242424242424242"
    fill_in "Expiration", with: "10/16"
    find_button("Update Reservation").click
    expect(page).to have_content("Greg's Homemade Chili")
    expect(page).to have_content("reserved")
    visit cart_properties_path
    expect(page).to_not have_content("Greg's Homemade Chili")
    expect(page).to have_content("empty")
  end

  it "must put an address to check out a delivery reservation" do
    property
    visit properties_path
    find_link("Add to Cart").click
    visit cart_properties_path
    find_link("Checkout").click
    check("Delivery?")
    fill_in "Card number", with: "4242424242424242"
    fill_in "Expiration", with: "10/16"
    find_button("Update Reservation").click
    expect(page).to have_content("address: can't be blank")
  end
end
