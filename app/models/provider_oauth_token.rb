class ProviderOauthToken < ApplicationRecord
  belongs_to :user
  attr_accessor :exchange_token

  def retrieve
    if provider == "facebook"
      res = ProviderOauthToken.get_facebook_access_token(exchange_token)
      json = JSON.parse(res.body)
      self.access_token = json["access_token"]
      self.expires_in = json["expires_in"]
    end
  end

  def self.get_facebook_access_token(exchange_token)
    resp = Faraday.get('https://graph.facebook.com/v10.0/oauth/access_token') do |req|
      req.params['grant_type'] = 'fb_exchange_token'
      req.params['client_id'] = ENV['FACEBOOK_CLIENT_ID']
      req.params['client_secret'] = ENV['FACEBOOK_CLIENT_SECRET']
      req.params['fb_exchange_token'] = exchange_token
    end
  end
end


# curl -i -X GET "https://graph.facebook.com/{graph-api-version}/oauth/access_token?  
#     grant_type=fb_exchange_token&          
#     client_id={app-id}&
#     client_secret={app-secret}&
#     fb_exchange_token={your-access-token}" 