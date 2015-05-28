require 'rails_helper'

describe "traveler permissions", type: :feature do
  let!(:user) { create(:user) }
  let!(:property) { create(:property) }
  let!(:reservation1) { create(:reservation, user: user, status: "completed", property: property) }

  it "can view own user info but not other users' info" do
    login(user)
    user2 = create(:user, name: "bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")

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
    login(user)
    user2 = create(:user,name: "bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")

    visit edit_user_path(user)
    fill_in "Email address", with: "boy_george@example.com"
    find_button("Update User").click
    expect(page).to have_content("boy_george@example.com")

    visit edit_user_path(user2)
    expect(current_path).to eq(root_path)
    expect(page).to have_content("You can only view your own")
  end

  it "sees error message when updating profile with invalid attributes" do
    login(user)
    visit edit_user_path(user)
    fill_in "Email address", with: ""
    find_button("Update User").click
    expect(page).to have_content("errors prohibited this user from being saved")
  end

  it "can view own reservations but not other users' reservations" do
    login(user)
    user2 = create(:user,name: "bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")
    reservation2 = create(:reservation, user: user2, status: "cancelled", property: property, start_date: Date.current.advance(days: 35), end_date: Date.current.advance(days: 40))

    visit reservations_path
    expect(page).to have_content(reservation1.status)
    visit reservation_path(reservation1.id)
    expect(page).to have_content(reservation1.total)
    expect(page).to have_content(reservation1.status)

    visit reservation_path(reservation2)
    expect(page).to have_content("You may only view your own reservations")
    expect(current_path).to eq(root_path)
  end

  it "can cancel a pending reservation" do
    login(user)
    reservation = create(:reservation, user: user)
    visit reservation_path(reservation)
    expect(page).to have_button("Cancel")
    find_button("Cancel").click
    expect(page).to have_content(reservation.property.title)
    expect(page).to have_content("cancelled")

    visit reservation_path(reservation1)
    expect(page).to_not have_button("Cancel")
  end

  it "cannot add properties" do
    login(user)
    visit new_property_path
    expect(page).to have_content("Unauthorized")
  end

  it "cannot access the my_guests page" do
    login(user)
    visit "/my_guests"
    expect(page).to have_content("You must be a host to see your guests")
    expect(current_path).to eq(root_path)
  end
end

describe "traveler permissions", type: :feature, js: true do
  let!(:user) { create(:user) }
  let!(:property) { create(:property) }

  it "can add and remove properties from a wish list" do
    visit login_path
    fill_in("email_address", with: user.email_address)
    fill_in("password", with: user.password)
    find_button("Login").click

    visit wishlist_path
    expect(page).to have_content("YOU DON'T HAVE ANYTHING ON YOUR WISHLIST")

    visit properties_path
    click_link_or_button property.title
    find(".wishlist").click
    expect(page).to have_content("Remove from Wishlist")

    visit wishlist_path
    expect(page).to have_content(property.title.upcase)

    click_link_or_button property.title
    find(".on-wishlist").click
    visit wishlist_path
    expect(page).not_to have_content(property.title)
  end
end
