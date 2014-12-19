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
      address = Address.create(attributes)
      expect(address).to be_valid

      attributes[:line_1] = nil
      address = Address.create(attributes)
      expect(address).to_not be_valid
    end

    it "must have a city" do
      attributes[:city] = nil
      address = Address.create(attributes)
      expect(address).to_not be_valid
    end

    it "must have a state" do
      attributes[:state] = nil
      address = Address.create(attributes)
      expect(address).to_not be_valid
    end

    it "must have a zip" do
      attributes[:zip] = nil
      address = Address.create(attributes)
      expect(address).to_not be_valid
    end

    it "defaults country to USA if not specified" do
      address = Address.create!(attributes)
      expect(address.country).to eq("USA")
    end

    it "returns a full street address string with line 1, city, state and zip" do
      address = Address.create!(attributes)
      expect(address.full_street_address).to eq("123 Some St. Denver CO 80203")
    end

    xit "geocodes lat and longitude when saving a record" do
      address = Address.create!(line_1: "1500 Sugar Bowl Dr",
                                city: "New Orleans",
                                state: "LA",
                                zip: "70112",)
      expect(address.latitude).to eq(29.9519198)
      expect(address.longitude).to eq(-90.080563)
    end
  end
end
