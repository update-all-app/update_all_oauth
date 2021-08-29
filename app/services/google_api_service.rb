# require 'signet/oauth_2/client'
# client = Signet::OAuth2::Client.new(
#   :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
#   :token_credential_uri =>  'https://oauth2.googleapis.com/token',
#   :client_id => "#{YOUR_CLIENT_ID}.apps.googleusercontent.com",
#   :client_secret => YOUR_CLIENT_SECRET,
#   :scope => 'email profile',
#   :redirect_uri => 'https://example.client.com/oauth'
# )

# client.code = request.query['code']
# client.fetch_access_token!
# ^^ https://github.com/googleapis/signet

class GoogleApiService < ApiService

  def self.get_access_token(code)
    resp = Faraday.get('') do |req|
      # TODO Rework from FB code to Google
      # req.params['grant_type'] = 'fb_exchange_token'
      # req.params['client_id'] = ENV['FACEBOOK_CLIENT_ID']
      # req.params['client_secret'] = ENV['FACEBOOK_CLIENT_SECRET']
      # req.params['fb_exchange_token'] = exchange_token
    end
    # not sure if this is doing too much here and possibly hiding error cases
    # that we're not aware of at the moment
    JSON.parse(resp.body)["access_token"]
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