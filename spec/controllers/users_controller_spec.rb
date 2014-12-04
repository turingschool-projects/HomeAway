require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let(:valid_attributes) { {name: "Viki",
                email_address: "viki@example.com",
                display_name: "viki",
                password: "password"
                } }
  let(:invalid_attributes) { {name: nil,
                              email_address: nil,
                              password: nil} }

  describe "POST create" do
    it "returns http success" do
      post :create, {user: valid_attributes}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end

    it "increases the User count by 1" do
      starting_count = User.all.count
      post :create, {user: valid_attributes}
      ending_count = User.all.count
      expect(ending_count).to eq(starting_count + 1)
    end

    it "will not create with invalid attributes" do
      starting_count = User.all.count
      post :create, {user: invalid_attributes}
      ending_count = User.all.count
      expect(ending_count).to eq(starting_count)
      expect(response).to render_template(:new)
    end
  end
end
