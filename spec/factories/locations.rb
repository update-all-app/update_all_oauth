FactoryBot.define do
  factory :location do
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zipcode { Faker::Address.zip }
    phone_number { Faker::PhoneNumber.phone_number }
    country { Faker::Address.country }
    business
  end
end
