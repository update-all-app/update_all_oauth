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
    with_options scope: :location_service, with_example: true do
      parameter :provider_oauth_token_id, "the id of the oauth token on our platform that has access to the page to be updated.", required: true
      parameter :location_id, "the id of the location on our platform for which a token will be used to update hours", required: true
      parameter :page_id, "a string representing the id of the page on the provider platform that will update. This information is accessible due to the access granted when a user authorizes UpdateItAll to access their account and information about pages to which access has been granted is stored in the provider oauth tokens table.", required: true
    end
    
    let(:provider_oauth_token_id) { @user.provider_oauth_token_ids.first }
    let(:location_id) { @user.location_ids.first }
    let(:page_id) { "#{(SecureRandom.rand*10000000000).round + 10000000000}" }

    let(:body) { 
      {
        location_service: {
          provider_oauth_token_id: provider_oauth_token_id,
          location_id: location_id,
          page_id: page_id
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


