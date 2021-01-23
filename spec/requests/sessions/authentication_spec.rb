require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  before(:all) do 
    @client = Doorkeeper::Application.create(name: "React client")
    ENV["REACT_CLIENT_UID"] = @client.uid
    ENV["REACT_CLIENT_SECRET"] = @client.secret
  end
  describe "POST /login" do
    it "responds with an access token that allows access to protected api endpoints" do
      # protected route should return 401 status code response
      get businesses_path
      expect(response).to have_http_status(401)
      # logging in will return a 200 status code with correct credentials
      @user = FactoryBot.create(:user)
      
      body = {
        user: {
          email: "test@test.com", 
          password: "password"
        }
      }
      post "/login", params: body

      expect(response).to have_http_status(200)
      
      # after authenticating, we can use the provided access_token to successfully
      # request a protected resource by passing the token in an authorization header
      @access_token = JSON.parse(response.body)["token"]["token"]
      headers = {
        "Authorization": "Bearer #{@access_token}",
        "Accept": "application/json"
      }
      get businesses_path, headers: headers
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /signup" do
    it "creates a new user and responds with an OAuth access token used to access protected resources" do
      body = {
        user: {
          email: "test@test.com", 
          password: "password"
        }
      }
      
      post "/signup", params: body
      
      expect(response).to have_http_status(200)
      
      @access_token = JSON.parse(response.body)["token"]["token"]
      headers = {
        "Authorization": "Bearer #{@access_token}",
        "Accept": "application/json"
      }
      get businesses_path, headers: headers
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /logout" do 
    it "revokes the current user's access token so it is unable to access protected routes" do 
      @user = FactoryBot.create(:user)
      @token = TokenService.new(user: @user).get_token
      @access_token = @token["token"]
      headers = {
        "Authorization": "Bearer #{@access_token}",
        "Accept": "application/json"
      }
      # check that headers with this valid access token allow access to protected resource
      get businesses_path, headers: headers
      expect(response).to have_http_status(200)
      
      # if valid token is included in headers, we get a successful logout response
      delete "/logout", headers: headers
      
      expect(response).to have_http_status(200)
      expect(response.body).to include("logged out successfully")

      # we should now be unable to access businesses with this revoked token
      get businesses_path, headers: headers
      expect(response).to have_http_status(401)

      # without proper headers, logout should return unauthorized
      delete "/logout"
      expect(response).to have_http_status(401)
    end
  end

  describe "POST /refresh_token" do 
    it "revokes previous access token and responds with a new access token generating using the refresh token" do 
      @user = FactoryBot.create(:user)
      @token = TokenService.new(user: @user).get_token
      @access_token_to_be_revoked = @token["token"]
      @refresh_token = @token["refresh_token"]

      headers = {
        "Authorization": "Bearer #{@refresh_token}",
        "Accept": "application/json"
      }
    
      # we are able to use the refresh_token to generate a new access token
      post "/refresh_token", headers: headers
      expect(response).to have_http_status(200)
      @new_token = JSON.parse(response.body)["token"]["token"]

      # the previous token should be unable to access protected resources
      get businesses_path, headers: {Authorization: "Bearer #{@access_token_to_be_revoked}"}
      expect(response).to have_http_status(401)

      # new token should be able to access protected resources
      headers["Authorization"] = "Bearer #{@new_token}"
      get businesses_path, headers: headers
      expect(response).to have_http_status(200)

      # original refresh token should no longer grant new access tokens 
      headers["Authorization"] = "Bearer #{@refresh_token}"
      post "/refresh_token", headers: headers
      expect(response).to have_http_status(422)

    end
  end
end
