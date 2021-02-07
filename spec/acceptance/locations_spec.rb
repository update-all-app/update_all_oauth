require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Locations" do
  
  
  get "/api/v1/locations" do
    example "Listing locations" do
      login_user
      header 'Accept', 'application/json'
      header 'Authorization', "Bearer #{@access_token}"
      do_request
      puts response_body
      expect(status).to eq 200
    end
  end
end