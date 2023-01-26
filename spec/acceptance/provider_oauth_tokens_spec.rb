require 'acceptance_helper'

resource "Provider OAuth Tokens" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"
  before(:all) do 
    load_client
    login_user(FactoryBot.create(:user, :with_businesses_and_locations))
  end

 

  post "/api/v1/provider_oauth_tokens" do 

    with_options scope: :provider_oauth_token, with_example: true do
      parameter :exchange_token, 'temporary token from provider to exchange for longer term access token', required: true
      parameter :provider, 'The provider this token was issued for', required: true
      parameter :provider_uid, "The user's account uid on the provider"
    end
    
    let(:stubbed_fb_exchange_token) { SecureRandom.hex(64) }
    let(:stubbed_fb_access_token) { SecureRandom.hex(86) }
    let(:facebook_account_id) { 12748318347 }
    let(:doubled_fb_service) { double(FacebookApiService) }
    let(:get_pages_response) {[
      {
        "access_token"=>stubbed_fb_access_token, 
        "category"=>"Musician/Band", 
        "category_list"=>[
          {
            "id"=>"180164648685982", 
            "name"=>"Musician/Band"
          }
        ], 
        "name"=>"Dakota Lee", 
        "id"=>"3748193847", 
        "tasks"=>[
          "ANALYZE", 
          "ADVERTISE", 
          "MESSAGING", 
          "MODERATE", 
          "CREATE_CONTENT", 
          "MANAGE"
        ]
      }, 
      {
        "access_token"=>stubbed_fb_access_token, 
        "category"=>"Musician/Band", 
        "category_list"=>[
          {
            "id"=>"180164648685982", 
            "name"=>"Musician/Band"
          }
        ], 
        "name"=>"SandraKota", 
        "id"=>"128748904856", 
        "tasks"=>[
          "ANALYZE", 
          "ADVERTISE", 
          "MESSAGING", 
          "MODERATE", 
          "CREATE_CONTENT", 
          "MANAGE"
        ]
      }
    ]}
   

    let(:body) { 
      {
        provider_oauth_token: {
          exchange_token: stubbed_fb_exchange_token,
          provider: "facebook",
          provider_uid: facebook_account_id
        }
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "Authorizing your UpdateItAll account to access Facebook businesses" do
      allow(FacebookApiService).to receive(:get_access_token).and_return(stubbed_fb_access_token)
      allow(FacebookApiService).to receive(:new).and_return(doubled_fb_service)
      allow(doubled_fb_service).to receive(:get_pages).and_return(get_pages_response)
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(201)
    end
  end

end


