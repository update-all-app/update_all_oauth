require 'acceptance_helper'

resource "Users & Authentication" do 
  header "Accept", "application/json"
  header "Content-Type", "application/json"
  header "Host", "https://update-it-all.dakotaleemartinez.com"
  before(:all) do 
    load_client
  end
  let(:user) { FactoryBot.create(:user, email: 'authtest@test.com') }
  post "/login" do 
    body = {
      user: {
        email: "authtest@test.com", 
        password: "password"
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    
    example "post '/login' with valid credentials" do
      explanation "when valid credentials are provided, the endpoint will respond with user data and an access token which may be used as an authorization header to access protected resources."
      user.provider_oauth_tokens.create(
        provider: ["Facebook"].sample, 
        provider_uid: rand(9959300543630775...10159300543630775),
        label: 'Page1, Page2'
      )
      do_request
      expect(status).to eq(200)
    end

    
    example "post '/login' with invalid credentials" do
      explanation "when invalid credentials are provided, a 401 status code is returned."
      body[:user][:password] = "wrongpassword"
      do_request
      expect(status).to eq(401)
    end
  end

  post "/signup" do 
    body = {
      user: {
        name: "tester",
        email: "test@test.com", 
        password: "password"
      }
    }
    let(:raw_post) { JSON.pretty_generate(body) }
    example "post '/signup' with valid params" do 
      explanation "when a name, email and password are provided responds with a 200 status code and user data."
      do_request
      expect(status).to eq(200)
    end

    example "post '/signup' with missing params" do 
      explanation "when a password is missing it returns a 422 status code" 
      body[:user][:password] = ""
      do_request
      expect(status).to eq(422)
    end
  end

  delete "/logout" do 
    example "delete '/logout' with valid auth header" do 
      explanation "If the request includes a valid access token, it returns a 200 status code and revokes the token so it will no longer provide access to protected resources."
      login_user(FactoryBot.create(:user))
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end

    example "delete '/logout' without valid auth header" do
      explanation "If the request doesn't include a valid access token, will respond with a 401 access code indicating there is no active session." 
      do_request
      expect(status).to eq(401)
    end
  end

  post "/refresh_token" do 
    example "post '/refresh_token' with valid refresh_token in headers" do 
      login_user(FactoryBot.create(:user)) 
      header "Authorization", "Bearer #{@refresh_token}"
      do_request
      expect(status).to eq(200)
    end

    example "post '/refresh_token' without valid refresh_token in headers" do 
      do_request
      expect(status).to eq(422)
    end
  end

  get "/api/v1/me" do 
    example "get '/api/v1/me' without valid headers" do 
      do_request
      expect(status).to eq(401)
    end

    example "get '/api/v1/me' with valid headers" do 
      explanation "when valid headers are presented, the endpoint will respond with user data and an array of services on which this user has authorized UpdateItAll to manage their businesses. The services will consist of the provider, provider_uid, and a label which indicates which pages/businesses connected to that provider account have been authorized as manageable by the access token returned from the Oauth consent flow."

      login_user(FactoryBot.create(:user, :with_services))
      header "Authorization", "Bearer #{@access_token}"
      do_request
      expect(status).to eq(200)
    end
  end

  put "/signup" do
    body = {
      user: {
        email: "updated@email.com",
        name: "Updated Name",
        payment_status_current: true
      }
    } 
    let(:raw_post) { JSON.pretty_generate(body) }
    example "put '/signup' with valid headers and params" do 
      login_user(FactoryBot.create(:user))
      header "Authorization", "Bearer #{@access_token}"
      
      do_request
      expect(status).to eq(200)
    end
  end
end


