require 'faker'
require 'factory_girl_rails'

class Seed
  def initialize
    generate_categories
    generate_hosts
    generate_travelers
    generate_properties
    generate_reservations
    generate_property_images
  end

  def generate_hosts
    @horace_user = FactoryGirl.create(:host,
      display_name: "Horace",
      name: "Horace Williams",
      email_address: "demo+horace@jumpstartlab.com",
      host_slug: nil,
      admin: true)

    @jorge_user = FactoryGirl.create(:host,
      display_name: "Jorge",
      name: "Jorge Tellez",
      email_address: "demo+jorge@jumpstartlab.com",
      admin: true)

    @hostess_user = FactoryGirl.create(:host,
      display_name: "Hostess",
      name: "Hostess Hosterson",
      email_address: "host@example.com")

    FactoryGirl.create_list(:host, 2)

    puts "Users generated"
  end

  def generate_travelers
    @traveler_user = FactoryGirl.create(:user,
      display_name: "Traveler",
      name: "Jim Jones",
      email_address: "travel@example.com")

    @travelers = 89.times { FactoryGirl.create(:user) }
  end

  def generate_categories
    @house     = FactoryGirl.create(:category, name: "House")
    @apartment = FactoryGirl.create(:category, name: "Apartment")
    @room      = FactoryGirl.create(:category, name: "Room")
    @cabin     = FactoryGirl.create(:category, name: "Cabin")
    @boat      = FactoryGirl.create(:category, name: "Boat")
    @balloon   = FactoryGirl.create(:category, name: "Balloon")
    @shack     = FactoryGirl.create(:category, name: "Shack")

    puts "Categories generated"
  end


  def generate_properties
    @hill_houses = FactoryGirl.create_list(:hill_house, 5,
                                           category: @house,
                                           user: User.where(host: true).limit(1).order("RANDOM()").take)

    @runs_houses = FactoryGirl.create_list(:runs_house, 5,
                                           category: @house,
                                           user: User.where(host: true).limit(1).order("RANDOM()").take)

    @pauls_boutiques = FactoryGirl.create_list(:pauls_boutique, 5,
                                               category: @apartment,
                                               user: User.where(host: true).limit(1).order("RANDOM()").take)

    @the_rooms = FactoryGirl.create_list(:the_room, 5,
                                         category: @room,
                                         user: User.where(host: true).limit(1).order("RANDOM()").take)

    @log_cabins = FactoryGirl.create_list(:log_cabin, 5,
                                          category: @cabin,
                                          user: User.where(host: true).limit(1).order("RANDOM()").take)

    puts "Properties generated"
  end

  def generate_reservations
    current = nil
    date_ranges = (1..50).map do
      current ||= Date.current..Date.current.advance(days: 2)
      num_days_after_start = current.last - current.first + 1
      num_days_after_end = current.last - current.first + 3
      start_date = current.first.advance(days: num_days_after_start)
      end_date = current.last.advance(days: num_days_after_end)
      current = start_date..end_date
    end

    date_ranges.each do |date_range|
      FactoryGirl.create(:reservation,
                        property: @hill_houses.sample,
                        user: User.limit(1).order("RANDOM()").take,
                        status: ["pending", "reserved", "completed", "cancelled"].sample,
                        start_date: date_range.first,
                        end_date: date_range.last)

      FactoryGirl.create(:reservation,
                        property: @runs_houses.sample,
                        user: User.limit(1).order("RANDOM()").take,
                        status: ["pending", "reserved", "completed", "cancelled"].sample,
                        start_date: date_range.first,
                        end_date: date_range.last)

      FactoryGirl.create(:reservation,
                        property: @pauls_boutiques.sample,
                        user: User.limit(1).order("RANDOM()").take,
                        status: ["pending", "reserved", "completed", "cancelled"].sample,
                        start_date: date_range.first,
                        end_date: date_range.last)

      FactoryGirl.create(:reservation,
                        property: @the_rooms.sample,
                        user: User.limit(1).order("RANDOM()").take,
                        status: ["pending", "reserved", "completed", "cancelled"].sample,
                        start_date: date_range.first,
                        end_date: date_range.last)

      FactoryGirl.create(:reservation,
                        property: @log_cabins.sample,
                        user: User.limit(1).order("RANDOM()").take,
                        status: ["pending", "reserved", "completed", "cancelled"].sample,
                        start_date: date_range.first,
                        end_date: date_range.last)
    end

    puts "Reservations generated"
  end

  def generate_property_images
    filenames = [ "ext_house_1.jpeg",
                  "ext_house_2.jpg",
                  "int_house_1.jpg",
                  "int_house_2.jpg",
                  "int_house_3.jpg",
                  "ext_apt_1.jpg",
                  "int_apt_1.jpg",
                  "int_apt_2.jpg",
                  "int_apt_3.jpg",
                  "ext_room_1.jpg",
                  "int_room_1.jpg",
                  "ext_cabin_1.jpg" ]

    @hill_houses.each do |house|
      photos = filenames.sample(3)
      Photo.create!(image_file_name: photos[0], property: house, primary: true)
      Photo.create!(image_file_name: photos[1], property: house)
      Photo.create!(image_file_name: photos[2], property: house)
    end

    @runs_houses.each do |house|
      photos = filenames.sample(3)
      Photo.create!(image_file_name: photos[0], property: house, primary: true)
      Photo.create!(image_file_name: photos[1], property: house)
      Photo.create!(image_file_name: photos[2], property: house)
    end

    @pauls_boutiques.each do |boutique|
      photos = filenames.sample(3)
      Photo.create!(image_file_name: photos[0], property: boutique, primary: true)
      Photo.create!(image_file_name: photos[1], property: boutique)
      Photo.create!(image_file_name: photos[2], property: boutique)
    end

    @the_rooms.each do |room|
      photos = filenames.sample(3)
      Photo.create!(image_file_name: photos[0], property: room, primary: true)
      Photo.create!(image_file_name: photos[1], property: room)
      Photo.create!(image_file_name: photos[2], property: room)
    end

    @log_cabins.each do |cabin|
      photos = filenames.sample(3)
      Photo.create!(image_file_name: photos[0], property: cabin, primary: true)
      Photo.create!(image_file_name: photos[1], property: cabin)
      Photo.create!(image_file_name: photos[2], property: cabin)
    end
  end
end

Seed.new
