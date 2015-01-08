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
      user = build(:user,valid_attributes)
      invalid_user = build(:user,invalid_attributes)
      expect(user).to be_valid
      expect(invalid_user).to_not be_valid
    end

    it "should not have an implausible email address" do
      user = build(:user, name: "Viki",
        email_address: "fsodubdfjb",
        password: "password",
        password_confirmation: "password")
      expect(user).to_not be_valid

      user = build(:user, name: "Viki",
      email_address: "viki@example,com",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid

      user = build(:user, name: "Viki",
      email_address: "viki_at_example.com",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid
    end

    it "should have a unique email address" do
      user = create(:user, name: "Viki",
      email_address: "viki@example.com",
      password: "password",
      password_confirmation: "password")

      user2 = build(:user, name: "Viki",
      email_address: "viki@example.com",
      password: "password",
      password_confirmation: "password")

      expect(user).to be_valid
      expect(user2).to_not be_valid
    end

    it "must have a name" do
      user = build(:user, name: "",
      email_address: "viki@example.com",
      password: "password",
      password_confirmation: "password")
      expect(user).to_not be_valid
    end

    it "can have an optional display name" do
      user = build(:user, name: "Viki",
      email_address: "viki1@example.com",
      password: "password",
      password_confirmation: "password")
      expect(user).to be_valid

      valid_attributes[:display_name] = "viki"
      user = build(:user,valid_attributes)
      expect(user).to be_valid
      expect(user.display_name).to eq("viki")
    end

    it "cannot have a display name under 2 characters" do
      user = build(:user, display_name: "v")
      expect(user).to_not be_valid
    end

    it "indicates if it is only a host and not an admin" do
      user = build(:user, admin: false, host: true)
      expect(user.only_host?).to be true
    end

  end

  describe "relationships" do
    let(:user) { create(:user,valid_attributes) }

    it "can have many reservations" do
      date = Date.today.advance(days: 10)
      reservation = create(:reservation,
                            start_date: date,
                            end_date: date.advance(days: 4),
                            user: user)
      reservation2 = create(:reservation,
                            property_id: 1,
                            start_date: date.advance(days: 5),
                            end_date: date.advance(days: 11),
                            user: user)

      expect(user.reservations).to include(reservation)
      expect(user.reservations).to include(reservation2)
      expect(user.reservations.count).to eq(2)
    end

    it "cannot be deleted while having properties" do
      user.properties << create(:property)
      expect{user.destroy}.to raise_error
    end

    it "can be deleted while having no properties" do
      expect{user.destroy}.to_not raise_error
    end
  end
end
