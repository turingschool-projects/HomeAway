require 'rails_helper'

describe SessionsController do
  describe '#create' do
    xit 'creates a session' do
      user_data = {name: "viki",
                   email_address: "viki@example.com",
                   password: "password",
                   password_confirmation: "password"}
      user = User.create(user_data)

      params[:email_address] = "viki@example.com"
      post :create
    end
  end
end
