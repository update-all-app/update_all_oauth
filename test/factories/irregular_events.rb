FactoryBot.define do
  factory :irregular_event do
    start_time { "2021-04-17 15:22:46" }
    end_time { "2021-04-17 17:22:46" }
    status { "open" }
    user

    trait :for_location do
      association :schedulable, factory: :location
    end

    trait :for_business do
      association :schedulable, factory: :business_with_locations
    end
  end
end
