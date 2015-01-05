FactoryGirl.define do
  factory :property do
    address
    user
    category


    sequence(:title) { |n| "Property Title #{n}" }
    sequence(:description) { |n| "Staying at #{title} is one of the best decisions you could ever make. It's awesome here."}
    price { (rand * 100) }
    retired false
    occupancy { (rand * 10).to_i }
    bathroom_private true

    factory :hill_house do
      sequence(:title) { |n| "Hill House #{n}" }
    end

    factory :runs_house do
      sequence(:title) { |n| "Run's House #{n}" }
    end

    factory :pauls_boutique do
      sequence(:title) { |n| "Paul's Boutique #{n}" }
    end

    factory :the_room do
      sequence(:title) { |n| "The Room #{n}" }
    end

    factory :log_cabin do
      sequence(:title) { |n| "Log Cabin #{n}" }
    end
  end
end
