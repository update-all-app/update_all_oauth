# Regular Events (times we're open)
# day_of_week:integer
# start_time:string (military time)
# end_time:string (military time)
# Irregular Events
# status:integer (enum for open and closed)
# start_time:datetime
# end_time:datetime

# overlapping events are not permitted on irregular events (custom validation)

# endpoints:
# get /api/v1/businesses/:id/regular_events
# post /api/v1/businesses/:id/regular_events
# patch /api/v1/regular_events/:id

# get /api/v1/businesses/:id/irregular_events
# post /api/v1/businesses/:id/irregular_events
# patch /api/v1/irregular_events/:id
require "acceptance_helper"

resource "Regular Events" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  get "/api/v1/locations/7/regular_events" do 
    example "regular events index for a particular location" do
      login_user(with_businesses: true, with_locations: true, with_location_regular_events: true)
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  get "/api/v1/businesses/12/regular_events" do 
    example "regular events index for a particular business" do 
      login_user(with_businesses: true, with_locations: true, with_business_regular_events: true)
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
  
end