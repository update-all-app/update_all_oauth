require 'signet/oauth_2/client'

# ^^ https://github.com/googleapis/signet

class GoogleApiService < ApiService
  attr_reader :client

  def self.create(code, pot)
    service = self.new(pot)
    service.create_client(code)
    service
  end

  def create_client(code)
    @client = Signet::OAuth2::Client.new(
      :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
      :token_credential_uri =>  'https://oauth2.googleapis.com/token',
      :client_id => ENV["GOOGLE_CLIENT_ID"],
      :client_secret => ENV["GOOGLE_CLIENT_SECRET"],
      :scope => 'email profile',
      :redirect_uri => 'postmessage'
    )

    client.code = code
    client.fetch_access_token!
    pot.access_token = client.access_token
    pot.provider_uid = client.decoded_id_token["sub"]
    pot.label = client.decoded_id_token["name"]
  end


  private 

  def google_secrets_json
    {
      "web": {
        "client_id": ENV["GOOGLE_CLIENT_ID"],
        "project_id":"updateitall",
        "auth_uri":"https://accounts.google.com/o/oauth2/auth",
        "token_uri":"https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs",
        "client_secret":ENV["GOOGLE_CLIENT_SECRET"],
        "redirect_uris":[ENV["GOOGLE_CLIENT_REDIRECT_URI"]],
        "javascript_origins":["https://updateitall.com"]
      }
    }.to_json
  end
end