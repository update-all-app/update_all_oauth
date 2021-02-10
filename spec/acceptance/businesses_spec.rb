require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Businesses" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  before(:all) do 
    load_client
  end
  get "/api/v1/businesses" do 
    example "get '/api/v1/businesses'" do 
      login_user(with_businesses: true, with_locations: true)
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  post "/api/v1/businesses" do 
    body = {
      business: {
        name: Faker::Company.name,
        email_address: Faker::Internet.email,
        phone_number: Faker::PhoneNumber.phone_number,
        locations_attributes: [
          {
            address_line_1: Faker::Address.street_address,
            address_line_2: Faker::Address.secondary_address,
            city: Faker::Address.city,
            state: Faker::Address.state,
            zipcode: Faker::Address.zip,
            country: Faker::Address.country,
            phone_number: Faker::PhoneNumber.phone_number
          }
        ]
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "post '/api/v1/businesses'" do 
      login_user
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end
end