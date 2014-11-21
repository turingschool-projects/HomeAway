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

    it 'has a signup link' do
      expect(page).to have_link('Sign Up')
    end

    it 'does not have a logout link' do
      expect(page).not_to have_link('Logout')
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
  end
end
