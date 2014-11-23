require 'rails_helper'

describe 'the unauthenticated user', type: :feature do

  let(:item) do
    category = Category.create!(name: "stuff")
    item_attributes = {title: "Greg's Homemade Chili",
                      description: "just like mom made it",
                      price: 15.50,
                      categories: [category]
                      }
    Item.create!(item_attributes)
  end

  it "browses all items" do
    item
    visit items_path
    expect(page).to have_content(item.title)
    expect(page).to have_content(item.description)
  end

  it 'browses items by category' do
    item
    visit items_path
    expect(page).to have_link("stuff", :href => "#category-id-#{item.categories.first.id}")
    expect(page).to have_css("span", "category-id-#{item.categories.first.id}")
  end

  xit "adds an item to the cart" do
  end

  xit 'views the cart' do
  end

  xit 'removes an item from the cart' do
  end

  xit 'increases the quantity of an item in the cart' do

  end

  xit 'logs in without clearing the cart' do
  end

  xit 'cannot checkout without logging in' do
  end

  xit 'cannot access admin views' do
  end

  xit 'cannot become an administrator' do

  end
end
