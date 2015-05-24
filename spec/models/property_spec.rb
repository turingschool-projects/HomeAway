require 'rails_helper'

RSpec.describe Property, :type => :model do
  describe "property attributes" do
    it "must have a title" do
      property = build(:property, title: nil)
      expect(property).to_not be_valid
    end

    it "must have a description" do
      property = build(:property, description: nil)
      expect(property).to_not be_valid
    end

    it "must have a description less than 500 characters" do
      property = build(:property, description: "super long description #{'.'*500}")
      expect(property).to_not be_valid
    end

   it "must have an address" do
      property = build(:property, address: nil)
      expect(property).to_not be_valid
    end

    it "must have a price that is greater than 0" do
      property = build(:property, price: 0)
      expect(property).to_not be_valid

      property = build(:property, price: -1)
      expect(property).to_not be_valid
    end

    it "must have a category" do
      property = build(:property, category: nil)
      expect(property).to_not be_valid
    end

    it "can be active or retired" do
      active_property = create(:property, retired: false)
      retired_property = create(:property, retired: true)

      expect(Property.active).to include(active_property)
      expect(Property.retired).to include(retired_property)
    end

    it "has a private or shared bathroom" do
      shared_bathroom = create(:property, bathroom_private: false)
      private_bathroom = create(:property, bathroom_private: true)

      expect(shared_bathroom.bathroom).to eq "Shared"
      expect(private_bathroom.bathroom).to eq "Private"
    end

    it "has a location that's equal to the city" do
      property = create(:property)
      expect(property.location).to eq property.address.city
    end

    it "has a daily rate" do
      property = create(:property, price: 5.00)
      expect(property.daily_rate).to eq 5.to_money
    end
  end

  describe "relationships" do
    it "belongs to a user" do
      property = create(:property)
      expect(property.user).to be_present
    end

    it "belongs to a category" do
      property = create(:property)
      expect(property.category).to be_present
    end

    it "belongs to an address" do
      property = create(:property)
      expect(property.address).to be_present
    end

    it "can have many reservations" do
      traveler = create(:user)
      property = create(:property)

      reservation1 = create(:reservation, user: traveler, property: property)

      reservation2 = create(:reservation, user: traveler, start_date: Date.current.advance(days: 20), end_date: Date.current.advance(days: 25), property: property)

      expect(property.reservations).to eq([reservation1, reservation2])
    end

    it "can have many photos" do
      property = create(:property)

      photo1 = create(:photo,image_file_name: "app/assets/images/ext_house_1.jpeg", property: property, primary: true)
      photo2 = create(:photo,image_file_name: "app/assets/images/int_house_1.jpg", property: property)

      expect(property.photos).to include(photo1)
      expect(property.photos).to include(photo2)
    end

    it "can identify its primary and other photos" do
      property = create(:property)

      photo1 = create(:photo,image_file_name: "app/assets/images/ext_house_1.jpeg", property: property, primary: true)
      photo2 = create(:photo,image_file_name: "app/assets/images/int_house_1.jpg", property: property)

      expect(property.primary).to eq photo1
      expect(property.other_photos).to include photo2
    end
  end
end
