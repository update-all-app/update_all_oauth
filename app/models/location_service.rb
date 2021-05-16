class LocationService < ApplicationRecord
  belongs_to :location
  belongs_to :provider_oauth_token
end
