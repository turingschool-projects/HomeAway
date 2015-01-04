require 'rails_helper'

RSpec.describe Address, :type => :model do
  describe "address attributes" do
    it "must have a street address" do
      address = build(:address)
      expect(address).to be_valid

      address = build(:address, line_1: nil)
      expect(address).to_not be_valid
    end

    it "must have a city" do
      address = build(:address, city: nil)
      expect(address).to_not be_valid
    end

    it "must have a state" do
      address = build(:address, state: nil)
      expect(address).to_not be_valid
    end

    it "must have a zip" do
      address = build(:address, zip: nil)
      expect(address).to_not be_valid
    end

    it "defaults country to USA if not specified" do
      address = create(:address)
      expect(address.country).to eq("USA")
    end

    it "returns an escaped city and address for google maps" do
      address = create(:address)
      address.city = "New York"
      expect(address.escape_city).to eq("New+York")
      expect(address.escape_street).to eq("123+Some+St")
    end
  end
end
