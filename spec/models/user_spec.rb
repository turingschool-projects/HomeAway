require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:valid_attributes) { {
    name: "Viki",
    email_address: "viki@example.com",
    password: "password",
    password_confirmation: "password"
    } }

    let(:invalid_attributes) { {
      name: nil,
      email_address: nil,
      password: nil,
      password_confirmation: nil
      } }

  describe "user attributes" do
    it "must have valid_attributes" do
      user = User.create(valid_attributes)
      invalid_user = User.create(invalid_attributes)
      expect(user).to be_valid
      expect(invalid_user).to_not be_valid
    end

    it "can have an optional display name" do
      valid_attributes[:display_name] = "viki"
      user = User.create(valid_attributes)
      expect(user).to be_valid
      expect(user.display_name).to eq("viki")
    end
  end

  describe "relationships" do
    let(:user) { User.create(valid_attributes) }

    it "can have many orders" do
      order = Order.create(delivery: true,
                           address: "123 Baker St",
                           user_id: user.id)
      order2 = Order.create(delivery: false,
                            user_id: user.id)

      expect(user.orders.first).to eq(order)
      expect(user.orders.last).to eq(order2)
      expect(user.orders.count).to eq(2)
    end

  end
end
