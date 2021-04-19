class RegularEventValueObject 
  attr_accessor :day_of_week, :start_time, :end_time, :schedulable_type
  
  def initialize(day_of_week:, start_time:, end_time:, schedulable_type:)
    @day_of_week = day_of_week
    @start_time = start_time
    @end_time = end_time
    @schedulable_type = schedulable_type
  end
end