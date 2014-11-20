require 'rails_helper'

describe 'the unauthenticated user', type: :feature do

  it "browses all items" do
    visit '/items'
    expect(page).to have_content('Burgers')
    expect(page).to have_content('Venison Burger')
  end

  it 'browses items by category' do

  end

  it "adds an item to the cart" do
  end

  it 'views the cart' do
  end

  it 'removes an item from the cart' do
  end

  it 'increases the quantity of an item in the cart' do

  end

  it 'logs in without clearing the cart' do
  end

  it 'cannot checkout without logging in' do
  end

  it 'cannot access admin views' do
  end

  it 'cannot become an administrator' do

  end
end
