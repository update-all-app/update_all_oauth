FactoryBot.define do
  factory :business do
    name { Faker::Company.name }
    email_address { Faker::Internet.email }
    user

    factory :business_with_locations do
      # locations_count is declared as a transient attribute available in the
      # callback via the evaluator
      transient do
        locations_count { 1 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |business, evaluator|
        create_list(:location, evaluator.locations_count, business: business)

        # You may need to reload the record here, depending on your application
        business.reload
      end
    end
  end
end
