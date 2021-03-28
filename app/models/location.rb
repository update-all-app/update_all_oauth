class Location < ApplicationRecord
  belongs_to :business
  has_many :regular_events, as: :schedulable
end
