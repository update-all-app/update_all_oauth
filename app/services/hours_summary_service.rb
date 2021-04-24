# Will receive an array of value objects for
# regular and irregular events
class HoursSummaryService
  attr_reader :start_date, :end_date, :regular_events, :irregular_events
  DAYS = {
    "monday" => 0,
    "tuesday" => 1,
    "wednesday" => 2,
    "thursday" => 3,
    "friday" => 4,
    "saturday" => 5,
    "sunday" => 6,
    0 => "monday",
    1 => "tuesday",
    2 => "wednesday",
    3 => "thursday",
    4 => "friday",
    5 => "saturday",
    6 => "sunday"
  }

  ScheduleEvent = Struct.new(
    :days_after_start, 
    :start_time, 
    :end_time
  )

  def initialize(regular_events:, irregular_events:, start_date:, end_date:)
    @regular_events = regular_events
    @irregular_events = irregular_events
    @start_date = start_date
    @end_date = end_date
  end

  def call 
    byebug
  end

  # build the week by iterating over the days between 
  # the start_day and end_day, creating events for each
  # day
  def build_week
    (start_date..end_date).map do |day|
      d = day.to_date
      irregular_for_the_day = irregular_events.select do |e|
        e.start_time.to_date == d
      end
      regular_for_the_day = regular_events.select do |e|
        e.day_of_week == DAYS[d.strftime('%A').downcase]
      end
      build_day(
        regular_events: regular_events, 
        irregular_events: irregular_events
      )
      
    end.flatten
  end

  # We'll need to make sure that irregular events only belong to a single day.

  def build_day(irregular_events:, regular_events:)
    if irregular_events.any?
      irregular_for_location = irregular_events.select {|e| e.schedulable_type == "Location"}
      if irregular_for_location.any? 
        irregular_for_location.select{|ie| ie.status == "open" }.map do |ie|
          ScheduleEvent.new(
            ie.days_from_start_date(start_date),
            ie.start_time_24hr,
            ie.end_time_24hr
          )
        end
      else
        # not going to be used for the near future
        nil
      end
    else
      # if there are no irregular events, make schedule events from regular events
      regular_events_for_loation = regular_events.select {|e| e.scheduleable_type == "Location"}
      if regular_events_for_location.any?
        regular_events_for_location.map do |reg_event| 
          ScheduleEvent.new(
            reg_event.day_from_week_start_at(start_date.wday),
            reg_event.start_time,
            reg_event.end_time
          )
        end
      else
        # not going to be used in the near future
        nil
      end
    end
  end

end