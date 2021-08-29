class ProviderOauthToken < ApplicationRecord
  belongs_to :user
  has_many :location_services, dependent: :destroy
  has_many :locations, through: :location_services

  def retrieve(short_term_creds)
    if provider == "facebook"
      token = short_term_creds[:exchange_token]
      self.access_token = FacebookApiService.get_access_token(exchange_token)
      # page access tokens don't expire so this is not needed here but we may need something like this for other providers
      # self.expires_at = DateTime.now + json["expires_in"].seconds
      # the pot is labeled with a comma separated list of the pages it can manage
      pages = FacebookApiService.new(self).get_pages
      self.label = pages.map{ |page| page["name"] }.join(', ')
      self.page_data = pages.map do |page| 
        {
          id: page["id"],
          name: page["name"],
          page_access_token: page["access_token"],
          instagram_is_connected: page["instagram_is_connected"]
        }
      end
    elsif provider == "google"
      
    end
  end

end