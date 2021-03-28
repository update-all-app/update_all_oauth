class Location < ApplicationRecord
  belongs_to :business
  has_many :regular_events, as: :schedulable
  has_many :irregular_events, as: :schedulable
end
