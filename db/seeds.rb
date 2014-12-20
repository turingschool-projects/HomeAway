require 'faker'

class Seed
  def initialize
    generate_users
    generate_categories
    generate_properties
    generate_reservations
    generate_addresses
    generate_property_images
  end

  def generate_users
    User.create!({
      display_name: "Horace",
      name: "Horace Williams",
      email_address: "demo+horace@jumpstartlab.com",
      password: "password",
      password_confirmation: "password",
      admin: true,
      host: true
    })

    User.create!({
      display_name: "Jorge",
      name: "Jorge Tellez",
      email_address: "demo+jorge@jumpstartlab.com",
      password: "password",
      password_confirmation: "password",
      admin: true,
      host: true
    })

    User.create!({
      display_name: "Traveler",
      name: "Jim Jones",
      email_address: "travel@example.com",
      password: "password",
      password_confirmation: "password",
      admin: false,
      host: false
    })

    User.create!({
      display_name: "Hostess",
      name: "Hostess Hosterson",
      email_address: "host@example.com",
      password: "password",
      password_confirmation: "password",
      admin: false,
      host: true
    })

    puts "Users generated"
  end

  def generate_categories
    Category.create!(name: "House")
    Category.create!(name: "Apartment")
    Category.create!(name: "Room")
    Category.create!(name: "Cabin")
    Category.create!(name: "Boat")
    Category.create!(name: "Balloon")
    Category.create!(name: "Shack")

    puts "Categories generated"
  end


  def generate_properties
    Property.create!(title: "Hill House",
                    price: 5500,
                    description: Faker::Lorem.sentence(2),
                    category_id: 1,
                    occupancy: 4)

    Property.create!(title: "Run's House",
                    price: 15000,
                    description: Faker::Lorem.sentence(3),
                    category_id: 1,
                    occupancy: 9)

     Property.create!(title: "Paul's Boutique",
                    price: 1000,
                    description: Faker::Lorem.sentence(3),
                    category_id: 2,
                    occupancy: 2)

      Property.create!(title: "The Room",
                    price: 500,
                    description: Faker::Lorem.sentence(1),
                    category_id: 3,
                    occupancy: 1)

      Property.create!(title: "Log Cabin",
                    price: 44500,
                    description: Faker::Lorem.sentence(1),
                    category_id: 4,
                    occupancy: 12)

    puts "Properties generated"
  end

  def generate_reservations

    date = Date.current

    Reservation.create!(status: "pending",
                        user_id: 3,
                        property_id: 1,
                        start_date: date,
                        end_date: date.advance(days: 4))


    Reservation.create!(status: "completed",
                        user_id: 3,
                        property_id: 3,
                        start_date: date.advance(days:-30),
                        end_date: date.advance(days:-25))

    Reservation.create!(status: "cancelled",
                        user_id: 2,
                        property_id: 4,
                        start_date: date.advance(days: -5),
                        end_date: date)

    Reservation.create!(status: "reserved",
                        user_id: 3,
                        property_id: 2,
                        start_date: date.advance(days: 10),
                        end_date: date.advance(days: 20))

    puts "Reservations generated"
  end

  def generate_addresses
    Property.all.each do |property|
      Address.create!(line_1: Faker::Address.street_address,
                      city: Faker::Address.city,
                      state: Faker::Address.state,
                      zip: Faker::Address.postcode,
                      country: Faker::Address.country
                     )
      property.address_id = Address.last.id
      property.save!
    end

    User.all.each do |user|
      Address.create!(line_1: Faker::Address.street_address,
                      city: Faker::Address.city,
                      state: Faker::Address.state,
                      zip: Faker::Address.postcode,
                      country: Faker::Address.country
                     )
      user.address_id = Address.last.id
      user.save!
    end
  puts "Addresses generated"

  end

  def generate_property_images
    image_path = Rails.root.join("app", "assets", "images")
    Photo.create!(image: File.open(image_path.join("ext_house_1.jpg")), property_id: 1, primary: true)
    Photo.create!(image: File.open(image_path.join("int_house_1.jpg")), property_id: 1)
    Photo.create!(image: File.open(image_path.join("int_house_2.jpg")), property_id: 1)

    Photo.create!(image: File.open(image_path.join("ext_house_1.jpg")), property_id: 2, primary: true)
    Photo.create!(image: File.open(image_path.join("int_house_3.jpg")), property_id: 2)

    Photo.create!(image: File.open(image_path.join("ext_apt_1.jpg")), property_id: 3, primary: true)
    Photo.create!(image: File.open(image_path.join("int_apt_1.jpg")), property_id: 3)
    Photo.create!(image: File.open(image_path.join("int_apt_2.jpg")), property_id: 3)
    Photo.create!(image: File.open(image_path.join("int_apt_3.jpg")), property_id: 3)

    Photo.create!(image: File.open(image_path.join("ext_room_1.jpg")), property_id: 4, primary: true)
    Photo.create!(image: File.open(image_path.join("int_room_1.jpg")), property_id: 4)

    Photo.create!(image: File.open(image_path.join("ext_cabin_1.jpg")), property_id: 5, primary: true)
  end
end

Seed.new
