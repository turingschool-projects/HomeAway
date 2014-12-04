require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the application', type: :feature do
  context 'when logged out' do
    before(:each) do
      visit root_path
    end

    it 'has a login button' do
      expect(page).to have_button('Login!')
    end

    it 'can visit a login page' do
      visit login_path
      expect(page).to have_field("email address")
      expect(page).to have_field("password")
      expect(page).to have_button("Login!")
    end

    it 'has a signup link' do
      expect(page).to have_link('Sign Up')
    end

    it 'does not have a logout link' do
      expect(page).not_to have_link('Logout')
    end

    it 'has a cart button' do
      expect(page).to have_link('Cart')
    end

    it 'does not have a profile link' do
      expect(page).not_to have_link('Profile')
    end

    it 'cannot edit user information' do
      visit '/users/1/edit'
      expect(current_path).to eq(root_path)
    end
  end

  context 'when logged in' do
    before(:each) do
      user_data = { name: "Viki",
                    email_address: "viki@example.com",
                    password: "password",
                    password_confirmation: "password" }
      user = User.create(user_data)
      visit root_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: user.password
      click_button "Login!"
    end

    it 'has a logout link' do
      expect(page).to have_link('Logout')
    end

    it 'does not have a login link' do
      expect(page).not_to have_link("Login!")
    end

    it 'can log out' do
      click_link "Logout"
      visit admin_items_path
      expect(page).to have_content("Unauthorized")
    end

    it 'it can view its profile' do
      expect(page).to have_link('Profile')
      click_link "Profile"
      expect(page).to have_content("Viki")
    end

    it 'can edit its profile' do
      click_link "Profile"
      expect(page).to have_link('Edit')
      click_link "Edit"
      expect(page).to have_content("Editing User Info")
      fill_in "user[email_address]", with: "joe@gmail.com"
      fill_in "user[name]", with: "joe"
      fill_in "user[display_name]", with: "joey99"
      click_link_or_button "Update User"
      expect(page).to have_content("joe@gmail.com")
      expect(page).to have_content("joe")
      expect(page).to have_content("joey99")
    end

    it 'edits profile invalid params redirect to edit form' do
      click_link "Profile"
      click_link "Edit"
      fill_in "user[display_name]", with: "this display name is going to be way too long so it will not pass the validations and redirect"
      click_link_or_button "Update User"
      expect(page).to have_content("Editing User Info")
    end

  end

  context 'invalid credentials' do
    let(:valid_credentials) {
      { name: "Viki",
        email_address: "viki@example.com",
        password: "password",
        password_confirmation: "password" }
    }
    let(:user) {
      User.create(valid_credentials)
    }
    it 'cannot log in without a valid password' do
      visit root_path
      fill_in "email_address", with: user.email_address
      fill_in "password", with: "p@55w0rd"
      click_button "Login!"
      expect(page).to have_content("Invalid Login")
    end
  end
end
