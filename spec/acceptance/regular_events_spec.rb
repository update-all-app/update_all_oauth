require "acceptance_helper"

resource "Regular Events for a Location" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"

  before(:all) do 
    login_user(with_businesses: true, with_locations: true, with_location_regular_events: true)
  end

  get "/api/v1/locations/:location_id/regular_events" do 
    let(:location_id) {@user.locations.first.id}
    example "Listing regular events for a particular location" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
  
  post "/api/v1/locations/:location_id/regular_events" do 
    body = {
      regular_event: {
        day_of_week: 0,
        start_time: '09:00',
        end_time: '17:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    let(:location_id) {@user.locations.first.id}
    example "Creating a regular event that belongs to a particular location" do 
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

  get "/api/v1/businesses/:business_id/regular_events" do 
    let(:business_id) {@user.businesses.first.id}
    example "Listing regular events for a particular business" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  post "/api/v1/businesses/:business_id/regular_events" do 
    body = {
      regular_event: {
        day_of_week: 0,
        start_time: '09:00',
        end_time: '17:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    let(:business_id) {@user.businesses.first.id}
    example "Creating a regular event that belongs to a particular business" do 
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

  patch "/api/v1/regular_events/:id" do 
    body = {
      regular_event: {
        day_of_week: 0,
        start_time: '09:00',
        end_time: '18:00'
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    let(:id) { @user.regular_events.last.id }
    example "Updating a regular event" do 
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  delete "/api/v1/regular_events/:id" do 
    let(:id) { @user.regular_events.last.id}
    example "Deleting a regular event" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end
end