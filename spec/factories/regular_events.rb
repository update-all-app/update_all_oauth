FactoryBot.define do
  factory :regular_event do
    day_of_week { 0 }
    start_time { "09:00" }
    end_time { "17:00" }
    user
    
    trait :for_location do
      association :schedulable, factory: :location
    end

    trait :for_business do
      association :schedulable, factory: :business_with_locations
    end
  end
end