class IrregularEvent < ApplicationRecord
  belongs_to :user
  belongs_to :schedulable, polymorphic: true
  enum status: [:open, :closed]

  def self.between(start_date, end_date)
    where("start_time BETWEEN ? AND ?", start_date, end_date)
  end

  def self.by_location(location)
    where(
      schedulable_id: location.id,
      schedulable_type: "Location"
    ).or(where(
      schedulable_id: location.business_id,
      schedulable_type: "Business"
    ))
  end

  def clone(attributes)
    s = self.schedulable
    u = self.user
    u.irregular_events.build(attributes.merge(schedulable: s))
  end
end
