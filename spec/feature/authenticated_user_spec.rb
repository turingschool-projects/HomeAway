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

  it "can view their past orders" do
    order1 = Order.create!(user: user, status: "completed")
    order2 = Order.create!(user: user, status: "cancelled")
    order3 = Order.create!(user: user, status: "paid")
    item2 = Item.create!(title: "retired", description: "retired", price: 5, categories: [category])
    order1.items << item
    order1.items << item2
    order2.items << item
    order3.items << item
    item2.retired = true
    expect(item2.retired?).to eq true

    visit orders_path
    expect(page).to have_content("completed")
    expect(page).to have_content("cancelled")
    expect(page).to have_content("paid")
    find(:xpath, "//a[@href='/orders/#{order1.id}']").click
    expect(page).to have_content order1.total
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
    expect(page).to have_content order1.total
    expect(page).to have_content order1.created_at
    expect(page).to have_content order1.updated_at
    within(".cart_item_#{item2.id} .title") do
      find_link("retired").click
      expect(page).to_not have_link_or_button("Add to Cart")
    end
  end
end
#       NOT allowed to:
#
#       view another user’s private data (such as current order, etc.)
#       view the administrator screens or use administrator functionality
#       make themselves an administrator
