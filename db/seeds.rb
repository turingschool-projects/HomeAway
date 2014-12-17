class Seed
  def initialize
    generate_users
    generate_categories
    generate_items
    generate_fillings
    generate_item_fillings
    generate_orders
  end

  def generate_users
    User.create!({
      display_name: "Horace Williams",
      email_address: "demo+horace@jumpstartlab.com",
      password: "password",
      password_confirmation: "password" 
      admin: true,
      host: true  
    })

    User.create!({
      display_name: "Jorge Tellez",
      email_address: "demo+jorge@jumpstartlab.com",
      password: "password",
      password_confirmation: "password",
      admin: true,
      host: true
    })

    User.create!({
      display_name: "Trevor",
      email_address: "trevor@email.com",
      password: "password",
      password_confirmation: "password",
      admin: false,
      host: false
    })

    User.create!({
      display_name: "Hostess",
      email_address: "hostess@email.com",
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


  appetizers = [
    deviled_quail_eggs = Property.create!(title: "Deviled Quail Eggs",
                                          description: "Free range quail eggs, perfect for sharing",
                                          price: 5.50, categories: [appetizer]),
    bison_chili_cheese_fries = Property.create!(title: "Bison Chili Cheese Fries",
                                                description: "Just like your regular chili cheese fries, but bison",
                                                price: 5.50, categories: [appetizer]),
    tomato_bruschetta = Property.create!(title: "Tomato Bruschetta",
                                         description: "Home grown tomatoes, herbs and onions on sliced baguette",
                                         price: 5.50, categories: [appetizer]),
    tomato_cheese_sandwich = Property.create!(title: "Tomato Cheese Sandwich",
                                              description: "Fresh tomatoes, spinach and cheese top a slice of fresh mountain bread",
                                              price: 5.50, categories: [appetizer]),
    lucky_soup = Property.create!(title: "Lucky Soup",
                                  description: "Creamy cheese soup topped with a four-leaf clover",
                                  price: 5.50, categories: [appetizer])
  ]
  image_path = Rails.root.join("app", "assets", "images")
  deviled_quail_eggs.image = File.open(image_path.join("deviled-quail-eggs.png"))
  bison_chili_cheese_fries.image = File.open(image_path.join("chili-cheese-fries.png"))
  tomato_bruschetta.image = File.open(image_path.join("tomato-bruschetta.png"))
  tomato_cheese_sandwich.image = File.open(image_path.join("tomato-veg-cheese-sandwich.png"))
  lucky_soup.image = File.open(image_path.join("lucky-soup.jpg"))
  appetizers.map(&:save)

  burgers = [
    bison_burger = Property.create!(title: "Bison Burger",
                                    description: "Free range bison meat with cheddar cheese grilled onions and mushrooms topped with a homemade pickle",
                                    price: 9.50, categories: [burger]),
    elk_burger = Property.create!(title: "Elk Burger",
                                  description: "Free range elk meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
                                  price: 11.75, categories: [burger]),
    moose_burger = Property.create!(title: "Moose Burger",
                                    description: "Free range moose meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
                                    price: 12.75, categories: [burger, local_game]),
    venison_burger = Property.create!(title: "Venison Burger",
                                      description: "Free range venison meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
                                      price: 8.75, categories: [burger]),
    bear_burger = Property.create!(title: "Bear Burger",
                                   description: "Free range bear meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
                                   price: 9.75, categories: [burger])
  ]
  bison_burger.image = File.open(image_path.join("gourmet_hamburger_with_bacon.jpg"))
  elk_burger.image = File.open(image_path.join("stacked_burger.jpg"))
  moose_burger.image = File.open(image_path.join("burger_hangover.jpg"))
  venison_burger.image = File.open(image_path.join("black_burger.png"))
  bear_burger.image = File.open(image_path.join("grange_burger.jpg"))
  burgers.map(&:save)

  entrees = [
    wild_boar_tenderloin = Property.create!(title: "Wild Boar Tenderloin",
                                            description: "Free range wild boar with tusks and stuff",
                                            price: 14.50, categories: [entree]),
    mountain_lion = Property.create!(title: "Mountain Lion",
                                     description: "Free range mountain lion steak with home grown french fries",
                                     price: 13.50, categories: [entree]),
    shepherds_pie = Property.create!(title: "Shepherd's Pie",
                                     description: "Free range mountain lamb baked in vegetables and potatoes",
                                     price: 12.50, categories: [entree]),
    chicken_pot_pie = Property.create!(title: "Mountain Chicken Pot Pie",
                                       description: "Free range mountain chicken baked in a pie with veggies",
                                       price: 11.50, categories: [entree])
  ]

  wild_boar_tenderloin.image = File.open(image_path.join("pork-tenderloin.png"))
  mountain_lion.image = File.open(image_path.join("mountain-lion-steak.jpg"))
  shepherds_pie.image = File.open(image_path.join("shepherds-pie.jpg"))
  chicken_pot_pie.image = File.open(image_path.join("chicken-pot-pie.jpg"))
  entrees.map(&:save)

  local_game_properties = [
    mountain_lion_stew = Property.create!(title: "Mountain Lion Stew",
                                          description: "Free range mountain lion stewed with carrots and potatoes",
                                          price: 13.50, categories: [entree, local_game]),
    wild_boar_ribs = Property.create!(title: "Wild Boar Ribs",
                                      description: "Free range wild boar ribs with barbecue sauce and stuff",
                                      price: 10.0, categories: [entree, local_game])
  ]
  mountain_lion_stew.image = File.open(image_path.join("mountain-lion-stew.jpg"))
  wild_boar_ribs.image = File.open(image_path.join("wild-boar-ribs.jpg"))
  local_game_properties.map(&:save)

  desserts = [
    chocolate_cake = Property.create!(title: "Chocolate Cake",
                                      description: "Free range cocoa beans and cane sugar",
                                      price: 4.50, categories: [dessert]),
    brownie_sundae = Property.create!(title: "Brownie Sundae",
                                      description: "Free range cocoa beans and cane sugar, plus ice cream",
                                      price: 4.50, categories: [dessert]),
    apple_pie = Property.create!(title: "Apple Pie",
                                 description: "Home grown apples baked in a delicious pie",
                                 price: 4.50, categories: [dessert]),
    apple_pie_a_la_mode = Property.create!(title: "Apple Pie A La Mode",
                                           description: "Home grown apples baked in a delicious pie, plus ice cream",
                                           price: 4.50, categories: [dessert])
  ]
  chocolate_cake.image = File.open(image_path.join("chocolate-cake.jpg"))
  brownie_sundae.image = File.open(image_path.join("brownie-sundae.jpg"))
  apple_pie.image = File.open(image_path.join("apple-pie.jpg"))
  apple_pie_a_la_mode.image = File.open(image_path.join("apple-pie-a-la-mode.jpg"))
  desserts.map(&:save)

  reservation1 = Reservation.create!(status: "completed",
                                     user: rachel)
  reservation1.properties << deviled_quail_eggs
  reservation1.properties << lucky_soup
  reservation1.properties << elk_burger

  reservation2 = Reservation.create!(status: "completed",
                                     user: jorge)
  reservation2.properties << bison_chili_cheese_fries
  reservation2.properties << bison_chili_cheese_fries
  reservation2.properties << wild_boar_tenderloin
  reservation2.properties << apple_pie_a_la_mode

  reservation3 = Reservation.create!(address: "123 Some St, Denver, CO",
                                     status: "cancelled",
                                     user: jeff)
  reservation3.properties << lucky_soup
  reservation3.properties << bear_burger
  reservation3.properties << brownie_sundae

  reservation4 = Reservation.create!(status: "cancelled",
                                     user: josh)
  reservation4.properties << chocolate_cake
  reservation4.properties << brownie_sundae
  reservation4.properties << apple_pie
  reservation4.properties << apple_pie_a_la_mode

  reservation5 = Reservation.create!(address: "123 Some Other St, Denver, CO",
                                     status: "reserved",
                                     user: rachel)
  reservation5.properties << bison_chili_cheese_fries
  reservation5.properties << bison_burger
  reservation5.properties << bison_burger

  reservation6 = Reservation.create!(user: rachel)
  reservation6.properties << deviled_quail_eggs
  reservation6.properties << deviled_quail_eggs
  reservation6.properties << deviled_quail_eggs
  reservation6.properties << deviled_quail_eggs

  reservation7 = Reservation.create!(user: jeff)
  reservation7.properties << tomato_bruschetta
  reservation7.properties << bison_burger
  reservation7.properties << moose_burger
  reservation7.properties << wild_boar_ribs
  reservation7.properties << tomato_cheese_sandwich

  reservation8 = Reservation.create!(user: josh,
                                     status: "paid")
  reservation8.properties << tomato_bruschetta
  reservation8.properties << shepherds_pie
  reservation8.properties << moose_burger
  reservation8.properties << bear_burger
  reservation8.properties << brownie_sundae
  reservation8.properties << apple_pie

  reservation9 = Reservation.create!(user: jorge,
                                     status: "reserved")
  reservation9.properties << bison_chili_cheese_fries
  reservation9.properties << tomato_cheese_sandwich
  reservation9.properties << elk_burger
  reservation9.properties << moose_burger

  reservation10 = Reservation.create!(user: josh,
                                      status: "reserved")
  reservation10.properties << lucky_soup

end

Seed.new
