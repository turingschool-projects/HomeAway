require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  let(:category) do
    Category.create!(name: "Room")
  end

  let(:user) do
    User.create!(name: "Bob", email_address: "bob@example.com", password: "password", password_confirmation: "password")
  end

  let(:address) do
    Address.create!(line_1: "123 S St", city: "Denver", state: "CO", zip: "80203")
  end

  describe "property attributes" do
    it "must have a title" do
      property = Property.create(description: "Super Cozy", price: 5000, category: category, address: address)
      expect(property).to_not be_valid
    end

    it "must have a description" do
      property = Property.create(title: "Bob's Place", price: 5000, category: category, address: address)
      expect(property).to_not be_valid
    end

    it "must have a description less than 500 characters" do
      property = Property.create(title: "Bob's Place", description: "Super long description #{'.'*500}", price: 5000, category: category, address: address)
      expect(property).to_not be_valid
    end

    it "must have an address" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, user: user, category: category)
      expect(property).to_not be_valid
    end

    it "must have a price that is greater than 0" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", category: category, address: address)
      expect(property).to_not be_valid

      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: -1, category: category, address: address)
      expect(property).to_not be_valid
    end

    it "must have a category" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address)
      expect(property).to_not be_valid
    end

    it "can be active or retired" do
      active_property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)
      retired_property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category, retired: true)

      expect(Property.active).to include(active_property)
      expect(Property.retired).to include(retired_property)
    end

    it "has a private or shared bathroom" do
      shared_bathroom = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category, bathroom_private: false)
      private_bathroom = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)

      expect(shared_bathroom.bathroom).to eq "Shared"
      expect(private_bathroom.bathroom).to eq "Private"
    end

    it "has a location" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user)
      expect(property.location).to eq "Denver"
    end

    it "has a daily rate" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user)
      expect(property.daily_rate).to eq 5.0
    end
  end

  describe "relationships" do
    it "belongs to a user" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user)
      expect(property.user).to eq(user)
    end

    it "belongs to a category" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)
      expect(property.category).to eq(category)
    end

    it "belongs to an address" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)
      expect(property.address).to eq(address)
    end

    it "can have many reservations" do
      traveler = User.create!(name: "Viki", email_address: "viki@example.com", password: "password", password_confirmation: "password")
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)

      reservation1 = Reservation.create!(user: traveler, start_date: Date.current, end_date: Date.current.advance(days: 4), property: property)

      reservation2 = Reservation.create!(user: traveler, start_date: Date.current.advance(days: 20), end_date: Date.current.advance(days: 25), property: property)

      expect(property.reservations).to eq([reservation1, reservation2])
    end

    it "can have many photos" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)

      photo1 = Photo.create!(image: File.open("app/assets/images/ext_house_1.jpg"), property: property, primary: true)
      photo2 = Photo.create!(image: File.open("app/assets/images/int_house_1.jpg"), property: property)

      expect(property.photos).to include(photo1)
      expect(property.photos).to include(photo2)
    end

    it "can identify its primary and other photos" do
      property = Property.create(title: "Bob's Place", description: "Super Cozy", price: 500, address: address, user: user, category: category)

      photo1 = Photo.create!(image: File.open("app/assets/images/ext_house_1.jpg"), property: property, primary: true)
      photo2 = Photo.create!(image: File.open("app/assets/images/int_house_1.jpg"), property: property)

      expect(property.primary).to eq photo1
      expect(property.other_photos).to include photo2
    end
  end
end
