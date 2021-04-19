FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }
    password { "password" }
    payment_status_current { false }
    name { "Tester" }

    # user_with_posts will create post data after the user has been created
    factory :user_with_businesses do
      # businesses_count is declared as a transient attribute available in the
      # callback via the evaluator
      transient do
        businesses_count { 5 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:business, evaluator.businesses_count, user: user)

        # You may need to reload the record here, depending on your application
        user.reload
      end
    end

    factory :user_with_businesses_and_locations do
      # businesses_count is declared as a transient attribute available in the
      # callback via the evaluator
      transient do
        businesses_count { 5 }
      end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |user, evaluator|
        create_list(:business_with_locations, evaluator.businesses_count, user: user)

        # You may need to reload the record here, depending on your application
        user.reload
      end
    end
  end
end
