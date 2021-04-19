class RegularEvent < ApplicationRecord
  belongs_to :user
  belongs_to :schedulable, polymorphic: true

  def self.by_location(location)
    where(
      schedulable_id: location.id,
      schedulable_type: "Location"
    ).or(where(
      schedulable_id: location.business_id,
      schedulable_type: "Business"
    ))
  end
end
