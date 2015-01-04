FactoryGirl.define do
  factory :reservation do
    start_date Date.current
    end_date Date.current.advance(days: 4)
  end
end
