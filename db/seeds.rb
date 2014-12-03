# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
appetizer = Category.create!(name: "Appetizers")
burger = Category.create!(name: "Burgers")
entree = Category.create!(name: "Entrees")
local_game = Category.create!(name: "Local Game")
dessert = Category.create!(name: "Desserts")

rachel = User.create!({
  name: "Rachel Warbelow",
  email_address: "demo+rachel@jumpstartlab.com",
  password: "password",
  password_confirmation: "password" })

jeff = User.create!({
  name: "Jeff",
  email_address: "demo+jeff@jumpstartlab.com",
  password: "password",
  password_confirmation: "password",
  display_name: "j3" })

jorge = User.create!({
  name: "Jorge Tellez",
  email_address: "demo+jorge@jumpstartlab.com",
  password: "password",
  password_confirmation: "password",
  display_name: "novohispano" })

josh = User.create!({ name: "Josh Cheek",
  email_address: "demo+josh@jumpstartlab.com",
  password: "password",
  password_confirmation: "password",
  display_name: "josh",
  admin: true })

appetizers = [
  deviled_quail_eggs = Item.create!(title: "Deviled Quail Eggs",
  description: "Free range quail eggs, perfect for sharing",
  price: 5.50, categories: [appetizer]),
  bison_chili_cheese_fries = Item.create!(title: "Bison Chili Cheese Fries",
  description: "Just like your regular chili cheese fries, but bison",
  price: 5.50, categories: [appetizer]),
  tomato_bruschetta = Item.create!(title: "Tomato Bruschetta",
  description: "Home grown tomatoes, herbs and onions on sliced baguette",
  price: 5.50, categories: [appetizer]),
  tomato_cheese_sandwich = Item.create!(title: "Tomato Cheese Sandwich",
  description: "Fresh tomatoes, spinach and cheese top a slice of fresh mountain bread",
  price: 5.50, categories: [appetizer]),
  lucky_soup = Item.create!(title: "Lucky Soup",
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
  bison_burger = Item.create!(title: "Bison Burger",
  description: "Free range bison meat with cheddar cheese grilled onions and mushrooms topped with a homemade pickle",
  price: 9.50, categories: [burger]),
  elk_burger = Item.create!(title: "Elk Burger",
  description: "Free range elk meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
  price: 11.75, categories: [burger]),
  moose_burger = Item.create!(title: "Moose Burger",
  description: "Free range moose meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
  price: 12.75, categories: [burger, local_game]),
  venison_burger = Item.create!(title: "Venison Burger",
  description: "Free range venison meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
  price: 8.75, categories: [burger]),
  bear_burger = Item.create!(title: "Bear Burger",
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
  wild_boar_tenderloin = Item.create!(title: "Wild Boar Tenderloin",
  description: "Free range wild boar with tusks and stuff",
  price: 14.50, categories: [entree]),
  mountain_lion = Item.create!(title: "Mountain Lion",
  description: "Free range mountain lion steak with home grown french fries",
  price: 13.50, categories: [entree]),
  shepherds_pie = Item.create!(title: "Shepherd's Pie",
  description: "Free range mountain lamb baked in vegetables and potatoes",
  price: 12.50, categories: [entree]),
  chicken_pot_pie = Item.create!(title: "Mountain Chicken Pot Pie",
  description: "Free range mountain chicken baked in a pie with veggies",
  price: 11.50, categories: [entree])
]

wild_boar_tenderloin.image = File.open(image_path.join("pork-tenderloin.png"))
mountain_lion.image = File.open(image_path.join("mountain-lion-steak.jpg"))
shepherds_pie.image = File.open(image_path.join("shepherds-pie.jpg"))
chicken_pot_pie.image = File.open(image_path.join("chicken-pot-pie.jpg"))
entrees.map(&:save)

local_game_items = [
  mountain_lion_stew = Item.create!(title: "Mountain Lion Stew",
  description: "Free range mountain lion stewed with carrots and potatoes",
  price: 13.50, categories: [entree, local_game]),
  wild_boar_ribs = Item.create!(title: "Wild Boar Ribs",
  description: "Free range wild boar ribs with barbecue sauce and stuff",
  price: 10.0, categories: [entree, local_game])
]
mountain_lion_stew.image = File.open(image_path.join("mountain-lion-stew.jpg"))
wild_boar_ribs.image = File.open(image_path.join("wild-boar-ribs.jpg"))
local_game_items.map(&:save)

desserts = [
  chocolate_cake = Item.create!(title: "Chocolate Cake",
  description: "Free range cocoa beans and cane sugar",
  price: 4.50, categories: [dessert]),
  brownie_sundae = Item.create!(title: "Brownie Sundae",
  description: "Free range cocoa beans and cane sugar, plus ice cream",
  price: 4.50, categories: [dessert]),
  apple_pie = Item.create!(title: "Apple Pie",
  description: "Home grown apples baked in a delicious pie",
  price: 4.50, categories: [dessert]),
  apple_pie_a_la_mode = Item.create!(title: "Apple Pie A La Mode",
  description: "Home grown apples baked in a delicious pie, plus ice cream",
  price: 4.50, categories: [dessert])
]
chocolate_cake.image = File.open(image_path.join("chocolate-cake.jpg"))
brownie_sundae.image = File.open(image_path.join("brownie-sundae.jpg"))
apple_pie.image = File.open(image_path.join("apple-pie.jpg"))
apple_pie_a_la_mode.image = File.open(image_path.join("apple-pie-a-la-mode.jpg"))
desserts.map(&:save)

order1 = Order.create!(status: "completed",
           user: rachel)
order1.items << deviled_quail_eggs
order1.items << lucky_soup
order1.items << elk_burger

order2 = Order.create!(status: "completed",
           user: jorge)
order2.items << bison_chili_cheese_fries
order2.items << bison_chili_cheese_fries
order2.items << wild_boar_tenderloin
order2.items << apple_pie_a_la_mode

order3 = Order.create!(delivery: true,
          address: "123 Some St, Denver, CO",
          status: "cancelled",
          user: jeff)
order3.items << lucky_soup
order3.items << bear_burger
order3.items << brownie_sundae

order4 = Order.create!(delivery: false,
          status: "cancelled",
          user: josh)
order4.items << chocolate_cake
order4.items << brownie_sundae
order4.items << apple_pie
order4.items << apple_pie_a_la_mode

order5 = Order.create!(delivery: true,
          address: "123 Some Other St, Denver, CO",
          status: "ordered",
          user: rachel)
order5.items << bison_chili_cheese_fries
order5.items << bison_burger
order5.items << bison_burger

order6 = Order.create!(user: rachel)
order6.items << deviled_quail_eggs
order6.items << deviled_quail_eggs
order6.items << deviled_quail_eggs
order6.items << deviled_quail_eggs

order7 = Order.create!(delivery: false,
          user: jeff)
order7.items << tomato_bruschetta
order7.items << bison_burger
order7.items << moose_burger
order7.items << wild_boar_ribs
order7.items << tomato_cheese_sandwich

order8 = Order.create!(delivery: false,
          user: josh,
          status: "paid")
order8.items << tomato_bruschetta
order8.items << shepherds_pie
order8.items << moose_burger
order8.items << bear_burger
order8.items << brownie_sundae
order8.items << apple_pie

order9 = Order.create!(delivery: false,
          user: jorge,
          status: "ordered")
order9.items << bison_chili_cheese_fries
order9.items << tomato_cheese_sandwich
order9.items << elk_burger
order9.items << moose_burger

order10 = Order.create!(delivery: false,
            user: josh,
            status: "ordered")
order10.items << lucky_soup
