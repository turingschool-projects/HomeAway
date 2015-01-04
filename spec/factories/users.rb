FactoryGirl.define do
  factory :user do
    address

    sequence(:email_address) { |n| "person#{n}@example.com" }
    sequence(:display_name) { |n| "DisplayPerson#{n}" }
    password "password"
    password_confirmation "password"
    admin false
    host false
    sequence(:name) { |n| "Person #{n}" }
    accepts_cc false
    accepts_cash false
    accepts_check false
    sequence(:host_slug) { |n| "Slug Person #{n}" }


    factory :admin do
      admin true
    end

    factory :host do
      host true
      accepts_cc false
      accepts_cash false
      accepts_check false
      sequence(:description) { |n| "All about staying with Person #{n}" }
    end
  end
end
