FactoryBot.define do
  factory :business do
    name { Faker::Company.name }
    email_address { Faker::Internet.email }
    user
  end
end
