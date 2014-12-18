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
  end
end
