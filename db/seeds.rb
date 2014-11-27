# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
categories = Category.create!([
  { name: "Appetizers" },
  { name: "Burgers" },
  { name: "Entrees" },
  { name: "Local Game" },
  { name: "Desserts" }
  ])

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

appetizers = Item.create!([
  { title: "Deviled Quail Eggs",
    description: "Free range quail eggs, perfect for sharing",
    price: 5.50 },
  { title: "Bison Chili Cheese Fries",
    description: "Just like your regular chili cheese fries, but bison",
    price: 5.50 },
  { title: "Tomato Bruschetta",
    description: "Home grown tomatoes, herbs and onions on sliced baguette",
    price: 5.50 },
  { title: "Tomato Cheese Sandwich",
    description: "Fresh tomatoes, spinach and cheese top a slice of fresh mountain bread",
    price: 5.50 },
  { title: "Lucky Soup",
    description: "Creamy cheese soup topped with a four-leaf clover",
    price: 5.50 }
    ])
appetizers[0].image = File.open("#{Rails.root}/app/assets/images/deviled-quail-eggs.png")
appetizers[0].save
appetizers[1].image = File.open("#{Rails.root}/app/assets/images/chili-cheese-fries.png")
appetizers[1].save
appetizers[2].image = File.open("#{Rails.root}/app/assets/images/tomato-bruschetta.png")
appetizers[2].save
appetizers[3].image = File.open("#{Rails.root}/app/assets/images/tomato-veg-cheese-sandwich.png")
appetizers[3].save
appetizers[4].image = File.open("#{Rails.root}/app/assets/images/lucky-soup.jpg")
appetizers[4].save

burgers = Item.create!([
  { title: "Bison Burger",
    description: "Free range bison meat with cheddar cheese grilled onions and mushrooms topped with a homemade pickle",
    price: 9.50 },
  { title: "Elk Burger",
    description: "Free range elk meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
    price: 11.75 },
  { title: "Moose Burger",
    description: "Free range moose meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
    price: 12.75 },
  { title: "Venison Burger",
    description: "Free range venison meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
    price: 8.75 },
  { title: "Bear Burger",
    description: "Free range bear meat with swiss cheese peppers and grilled onions topped with a homemade pickle",
    price: 9.75 }
    ])

entrees = Item.create!([
  { title: "Wild Boar Tenderloin",
    description: "Free range wild boar with tusks and stuff",
    price: 14.50 },
  { title: "Mountain Lion",
    description: "Free range mountain lion steak with home grown french fries",
    price: 13.50 },
  { title: "Shepherd's Pie",
    description: "Free range mountain lamb baked in vegetables and potatoes",
    price: 12.50 },
  { title: "Mountain Chicken Pot Pie",
    description: "Free range mountain chicken baked in a pie with veggies",
    price: 11.50}
    ])
entrees[0].image = File.open("#{Rails.root}/app/assets/images/pork-tenderloin.png")
entrees[0].save
entrees[1].image = File.open("#{Rails.root}/app/assets/images/mountain-lion-steak.jpg")
entrees[1].save
entrees[2].image = File.open("#{Rails.root}/app/assets/images/shepherds-pie.jpg")
entrees[2].save
entrees[3].image = File.open("#{Rails.root}/app/assets/images/chicken-pot-pie.jpg")
entrees[3].save

local_game = Item.create!([
  { title: "Mountain Lion Stew",
    description: "Free range mountain lion stewed with carrots and potatoes",
    price: 13.50 }
    ])
local_game[0].image = File.open("#{Rails.root}/app/assets/images/mountain-lion-stew.jpg")
local_game[0].save

desserts = Item.create!([
  { title: "Chocolate Cake",
    description: "Free range cocoa beans and cane sugar",
    price: 4.50 },
  { title: "Brownie Sundae",
    description: "Free range cocoa beans and cane sugar, plus ice cream",
    price: 4.50 },
  { title: "Apple Pie",
    description: "Home grown apples baked in a delicious pie",
    price: 4.50 },
  { title: "Apple Pie A La Mode",
    description: "Home grown apples baked in a delicious pie, plus ice cream",
    price: 4.50 }
  ])
desserts[0].image = File.open("#{Rails.root}/app/assets/images/chocolate-cake.jpg")
desserts[0].save
desserts[1].image = File.open("#{Rails.root}/app/assets/images/brownie-sundae.jpg")
desserts[1].save
desserts[2].image = File.open("#{Rails.root}/app/assets/images/apple-pie.jpg")
desserts[2].save
desserts[3].image = File.open("#{Rails.root}/app/assets/images/apple-pie-a-la-mode.jpg")
desserts[3].save

appetizer_items = ItemCategory.create!([
  { item_id: 1, category_id: 1 },
  { item_id: 2, category_id: 1 },
  { item_id: 3, category_id: 1 },
  { item_id: 4, category_id: 1 },
  { item_id: 5, category_id: 1 }
  ])

burger_items = ItemCategory.create!([
  { item_id: 6, category_id: 2 },
  { item_id: 7, category_id: 2 },
  { item_id: 8, category_id: 2 },
  { item_id: 9, category_id: 2 },
  { item_id: 10, category_id: 2 }
  ])

entree_items = ItemCategory.create!([
  { item_id: 11, category_id: 3 },
  { item_id: 12, category_id: 3 },
  { item_id: 13, category_id: 3 },
  { item_id: 14, category_id: 3 }
  ])

local_game_items = ItemCategory.create!([
  { item_id: 15, category_id: 4 },
  { item_id: 2, category_id: 4 },
  { item_id: 6, category_id: 4 },
  { item_id: 10, category_id: 4 }
  ])

dessert_items = ItemCategory.create!([
  { item_id: 16, category_id: 5 },
  { item_id: 17, category_id: 5 },
  { item_id: 18, category_id: 5 },
  { item_id: 19, category_id: 5 },
  { item_id: 20, category_id: 5 }
])

orders = Order.create!([
  { delivery: false,
    status: "completed",
    user_id: rachel.id },
  { delivery: false,
    status: "completed",
    user_id: jorge.id },
  { delivery: true,
    address: "123 Some St, Denver, CO",
    status: "cancelled",
    user_id: jeff.id },
  { delivery: false,
    status: "cancelled",
    user_id: josh.id },
  { delivery: true,
    address: "123 Some Other St, Denver, CO",
    user_id: rachel.id },
  { delivery: false,
    user_id: rachel.id },
  { delivery: false,
    user_id: jeff.id },
  { delivery: false,
    user_id: josh.id },
  { delivery: false,
    user_id: jorge.id },
  { delivery: false,
    user_id: josh.id }
  ])

order_items = OrderItem.create!([
  { order_id: 1, item_id: 1 },
  { order_id: 1, item_id: 5 },
  { order_id: 1, item_id: 7 },
  { order_id: 2, item_id: 2 },
  { order_id: 2, item_id: 2 },
  { order_id: 2, item_id: 11 },
  { order_id: 2, item_id: 20 },
  { order_id: 3, item_id: 5 },
  { order_id: 3, item_id: 10 },
  { order_id: 3, item_id: 18 },
  { order_id: 4, item_id: 17 },
  { order_id: 4, item_id: 18 },
  { order_id: 4, item_id: 19 },
  { order_id: 4, item_id: 20 },
  { order_id: 5, item_id: 2 },
  { order_id: 5, item_id: 6 },
  { order_id: 5, item_id: 6 },
  { order_id: 6, item_id: 1 },
  { order_id: 6, item_id: 1 },
  { order_id: 6, item_id: 1 },
  { order_id: 6, item_id: 1 },
  { order_id: 7, item_id: 3 },
  { order_id: 7, item_id: 6 },
  { order_id: 7, item_id: 10 },
  { order_id: 7, item_id: 15 },
  { order_id: 7, item_id: 4 },
  { order_id: 8, item_id: 3 },
  { order_id: 8, item_id: 13 },
  { order_id: 8, item_id: 10 },
  { order_id: 8, item_id: 11 },
  { order_id: 8, item_id: 18 },
  { order_id: 8, item_id: 19 },
  { order_id: 9, item_id: 2 },
  { order_id: 9, item_id: 4 },
  { order_id: 9, item_id: 6 },
  { order_id: 9, item_id: 8 },
  { order_id: 10, item_id: 5 }
  ])
