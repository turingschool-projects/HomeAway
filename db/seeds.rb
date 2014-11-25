# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
categories = Category.create([
  { name: "Appetizers" },
  { name: "Burgers" },
  { name: "Entrees" },
  { name: "Desserts" },
  { name: "Local Game" }])

users = User.create([
  { name: "Rachel Warbelow",
    email_address: "demo+rachel@jumpstartlab.com",
    password: "password",
    password_confirmation: "password" },
  { name: "Jeff",
    email_address: "demo+jeff@jumpstartlab.com",
    password: "password",
    password_confirmation: "password",
    display_name: "j3" },
  { name: "Jorge Tellez",
    email_address: "demo+jorge@jumpstartlab.com",
    password: "password",
    password_confirmation: "password",
    display_name: "novohispano" },
  { name: "Josh Cheek",
    email_address: "demo+josh@jumpstartlab.com",
    password: "password",
    password_confirmation: "password",
    display_name: "josh" }
  ])

foods = Item.create([
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
    price: 9.75 },


  { title: "Quail Eggs1",
    description: "Free range quail eggs with a bunch of stuff",
    price: 5.50 },
  { title: "Quail Eggs2",
    description: "Free range quail eggs with a bunch of stuff",
    price: 5.50 },
  { title: "Quail Eggs3",
    description: "Free range quail eggs with a bunch of stuff",
    price: 5.50 },
  { title: "Quail Eggs4",
    description: "Free range quail eggs with a bunch of stuff",
    price: 5.50 },
  { title: "Quail Eggs5",
    description: "Free range quail eggs with a bunch of stuff",
    price: 5.50 },


  { title: "Wild Boar Tenderloin1",
    description: "Free range wild boar with tusks and stuff",
    price: 14.50 },
  { title: "Wild Boar Tenderloin2",
    description: "Free range wild boar with tusks and stuff",
    price: 14.50 },
  { title: "Wild Boar Tenderloin3",
    description: "Free range wild boar with tusks and stuff",
    price: 14.50 },
  { title: "Wild Boar Tenderloin4",
    description: "Free range wild boar with tusks and stuff",
    price: 14.50 },
  { title: "Wild Boar Tenderloin5",
    description: "Free range wild boar with tusks and stuff",
    price: 14.50 },


  { title: "Chocolate Cake1",
    description: "Free range cocoa beans and cane sugar",
    price: 4.50 },
  { title: "Chocolate Cake2",
    description: "Free range cocoa beans and cane sugar",
    price: 4.50 },
  { title: "Chocolate Cake3",
    description: "Free range cocoa beans and cane sugar",
    price: 4.50 },
  { title: "Chocolate Cake4",
    description: "Free range cocoa beans and cane sugar",
    price: 4.50 },
  { title: "Chocolate Cake5",
    description: "Free range cocoa beans and cane sugar",
    price: 4.50 },



  { title: "Mountain Lion1",
    description: "Free range mountain lion steak with home grown french fries",
    price: 13.50 },
  { title: "Mountain Lion2",
    description: "Free range mountain lion steak with home grown french fries",
    price: 13.50 },
  { title: "Mountain Lion3",
    description: "Free range mountain lion steak with home grown french fries",
    price: 13.50 },
  { title: "Mountain Lion4",
    description: "Free range mountain lion steak with home grown french fries",
    price: 13.50 },
  { title: "Mountain Lion5",
    description: "Free range mountain lion steak with home grown french fries",
    price: 13.50 }

])

item_categories = ItemCategory.create([
  { item_id: 1, category_id: 2 },
  { item_id: 1, category_id: 5 },
  { item_id: 2, category_id: 2 },
  { item_id: 3, category_id: 2 },
  { item_id: 4, category_id: 2 },
  { item_id: 5, category_id: 2 },
  { item_id: 6, category_id: 1 },
  { item_id: 7, category_id: 1 },
  { item_id: 8, category_id: 1 },
  { item_id: 9, category_id: 1 },
  { item_id: 10, category_id: 1 },
  { item_id: 11, category_id: 3 },
  { item_id: 11, category_id: 5 },
  { item_id: 12, category_id: 3 },
  { item_id: 13, category_id: 3 },
  { item_id: 14, category_id: 3 },
  { item_id: 15, category_id: 3 },
  { item_id: 16, category_id: 4 },
  { item_id: 17, category_id: 4 },
  { item_id: 18, category_id: 4 },
  { item_id: 19, category_id: 4 },
  { item_id: 20, category_id: 4 },
  { item_id: 21, category_id: 5 },
  { item_id: 22, category_id: 5 },
  { item_id: 23, category_id: 5 },
  { item_id: 24, category_id: 5 },
  { item_id: 25, category_id: 5 }

])
