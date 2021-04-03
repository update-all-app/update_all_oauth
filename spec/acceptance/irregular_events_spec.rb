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
# get /api/v1/businesses/:id/irregular_events
# post /api/v1/businesses/:id/irregular_events
# patch /api/v1/irregular_events/:id

# get /api/v1/businesses/:id/irirregular_events
# post /api/v1/businesses/:id/irirregular_events
# patch /api/v1/irirregular_events/:id
require "acceptance_helper"

resource "Irregular Events for a Location" do 
  explanation "These endpoints are related to date-specific hours that will override regular hours for a particular date"
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_location_irregular_events: true)
  end

  get "/api/v1/locations/:location_id/irregular_events" do 
    let(:location_id) { @user.locations.first.id }
    example "Listing irregular events for a particular location" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
  
  post "/api/v1/locations/:location_id/irregular_events" do 
    let(:location_id) { @user.locations.first.id }
    body = {
      irregular_event: {
        status: 'closed',
        start_time: '2021-12-25 00:00:00',
        end_time: '2021-12-25 23:59:59'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Creating an irregular event that belongs to a particular location" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end
  
end

resource "Irregular Events for a Business" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_business_irregular_events: true)
  end

  get "/api/v1/businesses/:business_id/irregular_events" do 
    let(:business_id) { @user.businesses.first.id }
    example "Listing irregular events for a particular business" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  post "/api/v1/businesses/:business_id/irregular_events" do 
    let(:business_id) { @user.businesses.first.id }
    body = {
      irregular_event: {
        status: 'closed',
        start_time: '2021-12-25 00:00:00',
        end_time: '2021-12-25 23:59:59'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Creating an irregular event that belongs to a particular business" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end

end

resource "Irregular Events" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_location_irregular_events: true)
  end

  patch "/api/v1/irregular_events/:id" do 
    let(:id) { @user.irregular_events.last.id }
    body = {
      irregular_event: {
        status: 'open',
        start_time: '2021-12-24 9:00:00',
        end_time: '2021-12-24 13:00:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Updating an irregular event" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  delete "/api/v1/irregular_events/:id" do 
    let(:id) { @user.irregular_events.last.id }
    example "Deleting an irregular event" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
end