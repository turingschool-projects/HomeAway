require 'rails_helper'

describe "sign up process", type: :feature do
  it "should have a new user modal" do
    visit root_path
    expect(page).to have_field("Full Name")
    expect(page).to have_field("Email Address")
    expect(page).to have_field("(Optional) Display Name")
    expect(page).to have_field("Password")
    expect(page).to have_field("Confirm Password")
  end

  it "should log in a user upon sign-in" do
    visit root_path
    fill_in "Full Name", with: "Viki"
    fill_in "Email Address", with: "viki@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    find_button("Create User").click
    expect(current_path).to eq(edit_user_path(User.last))
    expect(page).to_not have_link("Log In")
    expect(page).to have_link("Logout")
  end

  it "should flash error message given invalid user attributes" do
    visit root_path
    find_button("Create User").click
    expect(page).to have_content("can't be blank")
  end
end
