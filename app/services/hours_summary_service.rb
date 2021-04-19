HoursSummaryService = Struct.new(
  :reg_events,
  :irreg_events,
  :start_date,
  :end_date
)
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
        irregular_events: irregular_events,
        day: d
      )
      
    end
  end

  # We'll need to make sure that irregular events only belong to a single day.

  def build_day(irregular_events:, regular_events:, day:)
    if irregular_events.any?
      irregular_for_location = irregular_events.select {|e| e.schedulable_type == "Location"}
      if irregular_for_location.any? 
        irregular_for_location.select{|ie| ie.status == "open" }.map do |ie|
          ScheduleEvent.new(
            ie.days_from_start_date(start_date),
            ie.start_time,
            ie.end_time
          )
        end
      else
        # not going to be used for the near future
      end
    else
      # if there are no irregular events, make schedule events from regular events
    end
  end

  def irregular_events
    @irregular_events ||= irreg_events.map do |irregular_event|
      IrregEvent.new(
        irregular_event.status,
        irregular_event.start_time,
        irregular_event.end_time,
        irregular_event.schedulable_type,
        false
      )
    end
  end

  def regular_events
    @regular_events ||= reg_events.map do |regular_event|
      RegEvent.new(
        regular_event.day_of_week,
        regular_event.start_time,
        regular_event.end_time,
        regular_event.schedulable_type,
        false
      )
    end
  end
end