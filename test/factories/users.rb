FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { "password" }
    payment_status_current { false }
    name { "Tester" }

    trait :with_businesses do
      transient do
        businesses_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:business, evaluator.businesses_count, user: user)

        # You may need to reload the record here, depending on your application
        user.reload
      end
    end

    trait :with_businesses_and_locations do 
      transient do
        businesses_count { 1 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:business, evaluator.businesses_count, :with_locations, user: user)

        # You may need to reload the record here, depending on your application
        user.reload
      end
    end

    trait :with_regular_events do
      with_businesses_and_locations
      transient do
        start_time { "09:00" }
        end_time { "17:00" }
        schedulable { "location" }
      end
   
      after(:create) do |user, evaluator|
        @schedulable = user.send("#{evaluator.schedulable}").first
        5.times do |i|
          FactoryBot.create(:regular_event, {
            user: user,
            schedulable: @schedulable,
            day_of_week: i + 1,
            start_time: evaluator.start_time,
            end_time: evaluator.end_time
          })
        end

        user.reload
      end
    end

    trait :with_irregular_events do
      with_businesses_and_locations
      transient do 
        start_time { (DateTime.now.beginning_of_week + 4.days + 9.hours).strftime('%Y-%m-%d %H:%M') }
        end_time { (DateTime.now.beginning_of_week + 4.days + 17.hours).strftime('%Y-%m-%d %H:%M') }
        schedulable { "location" }
      end

      after(:create) do |user, evaluator|
        @schedulable = user.send("#{evaluator.schedulable}").first
        FactoryBot.create(:irregular_event, {
          user: user,
          schedulable: @schedulable,
          start_time: evaluator.start_time,
          end_time: evaluator.end_time
        })
      end
    end

    trait :with_location_business_hours do 
      schedulable { "locations" }
      with_regular_events
      with_irregular_events
    end

    trait :with_business_hours do 
      schedulable { "businesses" }
      with_regular_events
      with_irregular_events
    end

    trait :with_services do 
      after(:create) do |user, evaluator|
        user.provider_oauth_tokens.create(
          provider: ["Facebook"].sample, 
          provider_uid: rand(9959300543630775...10159300543630775),
          label: 'Page1, Page2'
        )
      end
    end

    
  end
end
