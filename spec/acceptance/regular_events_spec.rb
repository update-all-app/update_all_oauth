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

resource "Regular Events for a Location" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_location_regular_events: true)
  end

  get "/api/v1/locations/7/regular_events" do 
    example "Listing regular schedule events for a particular location" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
  
  post "/api/v1/locations/11/regular_events" do 
    body = {
      regular_event: {
        day_of_week: 0,
        start_time: '09:00',
        end_time: '17:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Creating a regular schedule event that belongs to a particular location" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end
  
end

resource "Regular Events for a Business" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_business_regular_events: true)
  end

  get "/api/v1/businesses/12/regular_events" do 
    example "Listing regular schedule events for a particular business" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  post "/api/v1/businesses/12/regular_events" do 
    body = {
      regular_event: {
        day_of_week: 0,
        start_time: '09:00',
        end_time: '17:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Creating a regular schedule event that belongs to a particular business" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end

end

resource "Regular Events" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_location_regular_events: true)
  end

  patch "/api/v1/regular_events/17" do 
    body = {
      regular_event: {
        day_of_week: 0,
        start_time: '09:00',
        end_time: '18:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Updating a regular schedule event" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  delete "/api/v1/regular_events/17" do 
    example "Deleting a regular schedule event" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
end