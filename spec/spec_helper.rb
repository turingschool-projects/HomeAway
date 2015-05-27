require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end
require 'factory_girl_rails'
require 'faker'
require 'sucker_punch/testing/inline'
require 'capybara/poltergeist'
require 'database_cleaner'

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before :each do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :transaction
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

def login(user)
  visit root_path
  fill_in "email_address", with: user.email_address
  fill_in "password", with: user.password
  find_button("Login").click
end
