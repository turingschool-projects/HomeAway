require 'rails_helper'

RSpec.describe Address, :type => :model do
  let(:attributes) do
    {
      line_1: "123 Some St.",
      line_2: "Apt. 6",
      city: "Denver",
      state: "CO",
      zip: "80203"
    }
  end

  describe "address attributes" do
    it "must have a street address" do
      address = build(:address,attributes)
      expect(address).to be_valid

      attributes[:line_1] = nil
      address = build(:address,attributes)
      expect(address).to_not be_valid
    end

    it "must have a city" do
      attributes[:city] = nil
      address = build(:address,attributes)
      expect(address).to_not be_valid
    end

    it "must have a state" do
      attributes[:state] = nil
      address = build(:address,attributes)
      expect(address).to_not be_valid
    end

    it "must have a zip" do
      attributes[:zip] = nil
      address = build(:address,attributes)
      expect(address).to_not be_valid
    end

    it "defaults country to USA if not specified" do
      address = create(:address,attributes)
      expect(address.country).to eq("USA")
    end

    it "returns an escaped city and address for google maps" do
      address = create(:address,attributes)
      address.city = "New York"
      expect(address.escape_city).to eq("New+York")
      expect(address.escape_street).to eq("123+Some+St.")
    end
  end
end
