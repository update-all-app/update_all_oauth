require 'acceptance_helper'

resource "Location Services" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"
  before(:all) do 
    load_client
    login_user(FactoryBot.create(:user, :with_businesses_and_locations, :with_services))
  end

  post "/api/v1/location_services" do 
    # with_options with_example: true do
    #   parameter :provider_oauth_token_id, "1", required: true
    #   parameter :location_id, "1", required: true
    # end
    
    let(:provider_oauth_token_id) { @user.provider_oauth_token_ids.first }
    let(:location_id) { @user.location_ids.first }

    let(:body) { 
      {
        location_service: {
          provider_oauth_token_id: provider_oauth_token_id,
          location_id: location_id
        }
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Connecting a Location to an Authorized Service" do
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end

end


