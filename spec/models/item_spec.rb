require 'rails_helper'

describe Property do
  let(:category) { Category.create!(name: "nice name") }
  describe "validations" do
    it "validates title presence and uniqueness" do
      property = Property.create(description: "this is the title description", price: 10, categories: [category])
      expect(property).to_not be_valid

      property  = Property.create(title: "title", description: "this is the title description", price: 10, categories: [category])
      property2 = Property.create(title: "title", description: "this is the title description", price: 10, categories: [category])
      expect(property2).to_not be_valid
    end

    it "validates description" do
      property_without_description = Property.create(title: "property title", price: 15, categories: [category])
      expect(property_without_description).to_not be_valid

      property_desc_over_max = Property.create(title: "property title", price: 15, description: "this description is going to be way too long hopefully it's longer than 120 characters asdfjlaksdjflkasjdfkl;adjslkfjadskl;fjlakdsjfkladsjflkdasjflkadsjl;fj", categories: [category])
      expect(property_desc_over_max).to_not be_valid
    end

    it "validates price" do
      property_price_too_low = Property.create(title: "title", price: -1, description: "description", categories: [category])
      expect(property_price_too_low).to_not be_valid
    end
  end

  describe "relationships" do
    let(:property) do
      Property.create!(title: "title", price: 10, description: "description", categories: [category])
    end
    let(:user)  { User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password") }

    it "has many categories" do
      expect(property.categories).to eq([category])
    end

    it "has many reservations" do
      reservation = Reservation.create(user: user, properties: [property])
      expect(property.reservations).to eq([reservation])
    end
  end
end
