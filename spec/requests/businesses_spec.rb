require 'rails_helper'

RSpec.describe "Businesses", type: :request do
  context "authenticated" do 
    before(:all) do 
      login_user(FactoryBot.create(:user, :with_businesses))
    end
    describe "GET /api/v1/businesses" do
      it "returns a collection of businesses belonging to the current user" do
        get api_v1_businesses_path, headers: headers
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /api/v1/businesses" do
      it "allows the creation of a business and a location" do
        body = {
          business: {
            name: "UpdateItAll",
            email_address: "updateItAll@gmail.com",
            phone_number: Faker::PhoneNumber.phone_number,
            locations_attributes: [{
              address_line_1: Faker::Address.street_address,
              address_line_2: Faker::Address.secondary_address,
              city: Faker::Address.city,
              state: Faker::Address.state,
              zipcode: Faker::Address.zip,
              country: Faker::Address.country,
              phone_number: Faker::PhoneNumber.phone_number
            }]
          }
        }
        post api_v1_businesses_path, params: body.to_json, headers: headers
        expect(response).to have_http_status(201)
        business = Business.last
        expect(business.name).to eq(body[:business][:name])
        expect(business.email_address).to eq(body[:business][:email_address])
        expect(business.phone_number).to eq(body[:business][:phone_number])
        location = business.locations.last
        
        expect(location.address_line_1).to eq(body[:business][:locations_attributes][0][:address_line_1])
        expect(location.address_line_2).to eq(body[:business][:locations_attributes][0][:address_line_2])
        expect(location.city).to eq(body[:business][:locations_attributes][0][:city])
        expect(location.state).to eq(body[:business][:locations_attributes][0][:state])
        expect(location.zipcode).to eq(body[:business][:locations_attributes][0][:zipcode])
        expect(location.country).to eq(body[:business][:locations_attributes][0][:country])
        expect(location.phone_number).to eq(body[:business][:locations_attributes][0][:phone_number])
      end
    end
  end
end
