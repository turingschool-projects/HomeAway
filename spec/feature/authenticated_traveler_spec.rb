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

  it "can view own reservations but not other users' reservations" do
    login(user)
    user2 = create(:user,name: "bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")
    reservation2 = create(:reservation, user: user2, status: "cancelled", property: property, start_date: Date.current.advance(days: 35), end_date: Date.current.advance(days: 40))


    visit reservations_path
    expect(page).to have_content(reservation1.status)
    visit reservation_path(reservation1.id)
    expect(page).to have_content(reservation1.total)
    expect(page).to have_content(reservation1.status)

    visit reservation_path(reservation2.id)
    expect(page).to have_content("You may only view your own reservations")
    expect(current_path).to eq(root_path)
  end
end
