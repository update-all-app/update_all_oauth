class ProviderOauthToken < ApplicationRecord
  belongs_to :user

  def retrieve(exchange_token)
    if provider == "facebook"
      self.access_token = FacebookApiService.get_access_token(exchange_token)
      # page access tokens don't expire so this is not needed here but we may need something like this for other providers
      # self.expires_at = DateTime.now + json["expires_in"].seconds
      # the pot is labeled with a comma separated list of the pages it can manage
      self.label = FacebookApiService.new(self).get_pages
    end
  end

end


# curl -i -X GET "https://graph.facebook.com/{graph-api-version}/oauth/access_token?  
#     grant_type=fb_exchange_token&          
#     client_id={app-id}&
#     client_secret={app-secret}&
#     fb_exchange_token={your-access-token}" 