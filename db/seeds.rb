require 'faker'

class Seed
  def initialize
    generate_users
    generate_categories
    generate_properties
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
      email_address: "travel@email.com",
      password: "password",
      password_confirmation: "password",
      admin: false,
      host: false
    })

    User.create!({
      display_name: "Hostess",
      name: "Hostess Hosterson",
      email_address: "host@email.com",
      password: "password",
      password_confirmation: "password",
      admin: false,
      host: true
    })
  end

  def generate_categories
    Category.create!(name: "House")
    Category.create!(name: "Apartment")
    Category.create!(name: "Room")
    Category.create!(name: "Cabin")
    Category.create!(name: "Boat")
    Category.create!(name: "Balloon")
    Category.create!(name: "Shack")
  end


  def generate_properties
    Property.create!(title: "Sam's House",
                    price: 500,
                    description: Faker::Lorem.sentence(2),
                    category_id: 1,
                    occupancy: 4)

                     
  end
#  image_path = Rails.root.join("app", "assets", "images") 
#  deviled_quail_eggs.image = File.open(image_path.join("deviled-quail-eggs.png"))
#  reservation1 = Reservation.create!(status: "completed",
#                                     user: rachel)
#  reservation1.properties << deviled_quail_eggs
#  reservation1.properties << lucky_soup
#  reservation1.properties << elk_burger
#
#  reservation2 = Reservation.create!(status: "completed",
#                                     user: jorge)
#  reservation2.properties << bison_chili_cheese_fries
#  reservation2.properties << bison_chili_cheese_fries
#  reservation2.properties << wild_boar_tenderloin
#  reservation2.properties << apple_pie_a_la_mode
#
#  reservation3 = Reservation.create!(address: "123 Some St, Denver, CO",
#                                     status: "cancelled",
#                                     user: jeff)
#  reservation3.properties << lucky_soup
#  reservation3.properties << bear_burger
#  reservation3.properties << brownie_sundae
#
#  reservation4 = Reservation.create!(status: "cancelled",
#                                     user: josh)
#  reservation4.properties << chocolate_cake
#  reservation4.properties << brownie_sundae
#  reservation4.properties << apple_pie
#  reservation4.properties << apple_pie_a_la_mode
#
#  reservation5 = Reservation.create!(address: "123 Some Other St, Denver, CO",
#                                     status: "reserved",
#                                     user: rachel)
#  reservation5.properties << bison_chili_cheese_fries
#  reservation5.properties << bison_burger
#  reservation5.properties << bison_burger
#
#  reservation6 = Reservation.create!(user: rachel)
#  reservation6.properties << deviled_quail_eggs
#  reservation6.properties << deviled_quail_eggs
#  reservation6.properties << deviled_quail_eggs
#  reservation6.properties << deviled_quail_eggs
#
#  reservation7 = Reservation.create!(user: jeff)
#  reservation7.properties << tomato_bruschetta
#  reservation7.properties << bison_burger
#  reservation7.properties << moose_burger
#  reservation7.properties << wild_boar_ribs
#  reservation7.properties << tomato_cheese_sandwich
#
#  reservation8 = Reservation.create!(user: josh,
#                                     status: "paid")
#  reservation8.properties << tomato_bruschetta
#  reservation8.properties << shepherds_pie
#  reservation8.properties << moose_burger
#  reservation8.properties << bear_burger
#  reservation8.properties << brownie_sundae
#  reservation8.properties << apple_pie
#
#  reservation9 = Reservation.create!(user: jorge,
#                                     status: "reserved")
#  reservation9.properties << bison_chili_cheese_fries
#  reservation9.properties << tomato_cheese_sandwich
#  reservation9.properties << elk_burger
#  reservation9.properties << moose_burger
#
#  reservation10 = Reservation.create!(user: josh,
#                                      status: "reserved")
#  reservation10.properties << lucky_soup
#
end

Seed.new
