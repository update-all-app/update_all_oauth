class RegularEventValueObject 
  attr_accessor :day_of_week, :start_time, :end_time, :schedulable_type
  
  def initialize(day_of_week:, start_time:, end_time:, schedulable_type:)
    @day_of_week = day_of_week
    @start_time = start_time
    @end_time = end_time
    @schedulable_type = schedulable_type
  end

  # Get the relative day of the week given an 
  # arbitrary "start" of the week. EG if the week starts
  # on a Wednesday, Thrusday would be 1, and Tuesday would be 6
  # Expect day_of_week_start to be an int, 0-6 -> Sunday-Saturday
  def day_from_week_start_at(day_of_week_start)
    (day_of_week - day_of_week_start) % 7
  end
end