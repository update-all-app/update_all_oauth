class Business < ApplicationRecord
  belongs_to :user
  has_many :locations
  has_many :regular_events, as: :schedulable
  has_many :irregular_events, as: :schedulable
  accepts_nested_attributes_for :locations
end
