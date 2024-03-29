class Location < ApplicationRecord
  belongs_to :business
  has_many :regular_events, as: :schedulable
  has_many :irregular_events, as: :schedulable
  has_many :location_services
  has_many :provider_oauth_tokens, through: :location_services
  has_many :hours_updates
  
  def last_update
    hours_updates.last
  end
end
