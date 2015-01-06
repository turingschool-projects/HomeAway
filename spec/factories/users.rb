FactoryGirl.define do
  factory :user do
    address

    name { Faker::Name.name }
    sequence(:email_address) { |n| "#{name.downcase.parameterize}#{n}@example.com" }
    sequence(:display_name) { |n| "#{name}#{n}" }
    password "password"
    password_confirmation "password"
    admin false
    host false
    accepts_cc false
    accepts_cash false
    accepts_check false
    host_slug nil

    factory :admin do
      admin true
    end

    factory :host do
      host true
      accepts_cc false
      accepts_cash false
      accepts_check false
      sequence(:description) { |n| "All about staying with #{name} #{n}" }
      sequence(:host_slug) { |n| "#{name.downcase.parameterize}-#{n}" }
    end
  end
end
