class FacebookApiService
  attr_reader :pot

  def self.get_access_token(exchange_token)
    resp = Faraday.get('https://graph.facebook.com/v10.0/oauth/access_token') do |req|
      req.params['grant_type'] = 'fb_exchange_token'
      req.params['client_id'] = ENV['FACEBOOK_CLIENT_ID']
      req.params['client_secret'] = ENV['FACEBOOK_CLIENT_SECRET']
      req.params['fb_exchange_token'] = exchange_token
    end
    # not sure if this is doing too much here and possibly hiding error cases
    # that we're not aware of at the moment
    JSON.parse(resp.body)["access_token"]
  end

  def initialize(provider_oauth_token)
    @pot = provider_oauth_token
  end

  def get_pages
    res = Faraday.get("https://graph.facebook.com/me/accounts") do |req|
      req.params['access_token'] = pot.access_token
    end
    json = JSON.parse(res.body)
    json["data"]
  end
end