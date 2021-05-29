class ProviderOauthToken < ApplicationRecord
  belongs_to :user
  has_many :location_services
  has_many :locations, through: :location_services
  attr_accessor :pages

  def retrieve(exchange_token)
    if provider == "facebook"
      self.access_token = FacebookApiService.get_access_token(exchange_token)
      # page access tokens don't expire so this is not needed here but we may need something like this for other providers
      # self.expires_at = DateTime.now + json["expires_in"].seconds
      # the pot is labeled with a comma separated list of the pages it can manage
      pages = FacebookApiService.new(self).get_pages
      self.label = pages.map{ |page| page["name"] }.join(', ')
      self.page_data = pages.map do |page| 
        {
          id: page["id"],
          name: page["name"]
        }
      end
    end
  end

end