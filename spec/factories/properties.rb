FactoryGirl.define do
  factory :property do
    address
    user
    category


    sequence(:title) { |n| "Title #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    price { (rand * 100) }
    retired false
    occupancy { (rand * 10).to_i }
    bathroom_private true
  end
end
