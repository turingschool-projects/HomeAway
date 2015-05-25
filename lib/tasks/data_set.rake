require 'active_record'
require 'populator'
require 'csv'
require 'faker'

namespace :db do
  desc "Load db from pg_dump file"
  task :pg_load, [:pg_file] => :environment do |t, args|
    db_name = ActiveRecord::Base.connection.current_database
    puts "Restting the current state of #{db_name}"
    system("rake db:drop")
    system("rake db:create")
    puts "Loading database #{arg[:pg_file]}..."
    system("psql -d #{db_name} -f test.sql")
  end

  desc "Create a pg_dump file from your dev db in the current rails directory"
  task :pg_dump do
    db_name = ActiveRecord::Base.connection.current_database
    system("pg_dump --no-owner #{db_name} > #{db_name}.sql")
  end

  desc "Insert 800 users, 500,000 proporties, 7 categories"
  task :insert_mass_data do
    system("rake db:schema:load")
    system("rake db:seed")
    User.populate(800) do |user|
      user.name = Faker::Name.name,
      user.display_name  = Faker::Internet.user_name(user.name),
      user.email_address = Faker::Internet.email(user.name)
    end

    categories.each do |category|
      @category_id = Category.find_by(name: category).id
      @hosts = User.where(host: true)
      @n = 0
      @title = property_titles[categories.index(category)]
      Property.populate(100000) do |property|
        property.user_id          = @hosts.sample.id
        property.title            = "#{@title} #{@n += 1}"
        property.price_cents      = 1000..9900
        property.retired          = false
        property.address_id       = create_address_from_csv(address(@n))
        property.category_id      = @category_id
        property.occupancy        = 1..10
        property.bathroom_private = true
        property.description      = "Staying at #{property.title} is one "\
          "of the best decisions you could ever make. It's awesome here."
        images = image_files.sample(3)
        Photo.populate(3) do |photo|
          photo.property_id = property.id
          photo.image_file_name = images.pop
        end
      end
    end

    categories.each do |category|
      @category_properties = Property.joins(:category).where(categories: {name: category} )
      @r = 0
      Reservation.populate(100) do |reservation|
        @r += 1
        reservation.property_id = @category_properties.sample.id
        reservation.user_id     = User.limit(1).order("RANDOM()").take.id
        reservation.status      = statuses.sample
        reservation.start_date  = date_ranges[@r].first
        reservation.end_date    = date_ranges[@r].last
      end
    end
  end

  def statuses
    ["pending", "reserved", "completed", "cancelled"]
  end

  def categories
    ["House", "Apartment", "Room", "Cabin", "Boat"]
  end

  def property_titles
    ["Hill House", "Pauls Boutique", "The Room", "Log Cabin", "S. S. Minnow"]
  end

  def image_files
    [ "ext_house_1.jpeg",
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
  end

  def date_ranges
    current = nil
    date_ranges = (1..200).map do
      current ||= Date.current..Date.current.advance(days: 2)
      num_days_after_start = current.last - current.first + 1
      num_days_after_end = current.last - current.first + 3
      start_date = current.first.advance(days: num_days_after_start)
      end_date = current.last.advance(days: num_days_after_end)
      current = start_date..end_date
    end
    date_ranges
  end

  def create_address_from_csv(csv_row)
    address = Address.new
    address.line_1 = csv_row[:line_1]
    address.city = csv_row[:city]
    address.state = csv_row[:state]
    address.zip = csv_row[:zip]
    address.save
    address.id
  end
  def address(n)
    @adderss_csv ||= csv_load
    @addresses[n]
  end

  def csv_load
    @addresses = CSV.read(Rails.root.join('spec', 'fixtures', 'addresses.csv'),
                          headers: true, header_converters: :symbol)
    250.times do
      CSV.read(Rails.root.join('spec', 'fixtures', 'addresses.csv'),
               headers: true, header_converters: :symbol).each do |address|
        @addresses << address
      end
    end
    @addresses
  end
end
