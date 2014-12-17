require 'rails_helper'

describe 'the unauthenticated user', type: :feature do
  let(:category) { Category.create!(name: "stuff") }
  let(:property) do
    Property.create!(title: "Greg's Homemade Chili",
    description: "just like mom made it",
    price: 15.50,
    categories: [category])
  end

  let(:user_attributes) do
    { name: "Boy George",
      email_address: "cultureclubforever@eighties.com",
      password: "password",
      password_confirmation: "password"
    }
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

  it 'logs in without clearing the cart' do
    property
    user = User.create!(user_attributes)
    visit properties_path
    find_link("Add to Cart").click
    fill_in "email address", with: user.email_address
    fill_in "password", with: "password"
    find_button("Login!").click
    visit cart_properties_path
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.price)
    expect(page).to have_content("Quantity")
    within(".cart_property_#{property.id} .quantity") do
      expect(page).to have_content("1")
    end
  end

  it 'cannot checkout without logging in' do
    property
    visit properties_path
    find_link("Add to Cart").click
    visit cart_properties_path
    find_link("Checkout").click
    expect(current_path).to eq(login_path)
  end

  it 'cannot access admin views' do
    visit admin_properties_path
    expect(page.current_path).to eq(root_path)
    expect(page).to have_content('Unauthorized')
  end

  it 'cannot become an administrator' do
    visit new_user_path
    fill_in("Full Name", with: user_attributes[:name])
    fill_in("Email Address", with: user_attributes[:email_address])
    fill_in("Password", with: user_attributes[:password])
    fill_in("Confirm Password", with: user_attributes[:password])
    click_button("Create User")
    expect(User.last.name).to eq(user_attributes[:name])
    expect(User.last.admin?).to be false
  end
end
