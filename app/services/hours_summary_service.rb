# Will receive an array of value objects for
# regular and irregular events
class HoursSummaryService
  attr_reader :user, :location, :start_date, :end_date, :regular_events, :irregular_events
  DAYS = {
    "monday" => 1,
    "tuesday" => 2,
    "wednesday" => 3,
    "thursday" => 4,
    "friday" => 5,
    "saturday" => 6,
    "sunday" => 0,
    1 => "monday",
    2 => "tuesday",
    3 => "wednesday",
    4 => "thursday",
    5 => "friday",
    6 => "saturday",
    0 => "sunday"
  }

  ScheduleEvent = Struct.new(
    :days_after_start, 
    :weekday,
    :start_time, 
    :end_time
  )

  def initialize(user:, location:, start_date:, end_date:)
    @user = user
    @location = location
    @start_date = start_date
    @end_date = end_date
    @regular_events = user.regular_events.by_location(location).map do |re|
      RegularEventValueObject.new(
        day_of_week: re.day_of_week,
        start_time: re.start_time,
        end_time: re.end_time,
        schedulable_type: re.schedulable_type
      )
    end
    @irregular_events = user.irregular_events.between(start_date, end_date).by_location(location).map do |ie|
      IrregularEventValueObject.new(
        status: ie.status,
        start_time: ie.start_time,
        end_time: ie.end_time,
        schedulable_type: ie.schedulable_type
      )
    end
  end

  def call 
    build_week.compact.map(&:to_h)
  end

  # build the week by iterating over the days between 
  # the start_day and end_day, creating events for each
  # day
  def build_week
    (start_date..end_date).map.with_index do |day, index|
      d = day.to_date
      irregular_for_the_day = irregular_events.select do |e|
        e.start_time.to_date == d
      end
      regular_for_the_day = regular_events.select do |e|
        e.day_of_week == DAYS[d.strftime('%A').downcase]
      end
      build_day(
        days_after_start: index,
        regular_events: regular_for_the_day, 
        irregular_events: irregular_for_the_day
      )
      
    end.flatten
  end

  # We'll need to make sure that irregular events only belong to a single day.

  def build_day(irregular_events:, regular_events:, days_after_start:)
    if irregular_events.any?
      irregular_for_location = irregular_events.select {|e| e.schedulable_type == "Location"}
      if irregular_for_location.any? 
        irregular_for_location.select{|ie| ie.status == "open" }.map do |ie|
          ScheduleEvent.new(
            days_after_start,
            ie.start_time.strftime("%a").downcase,
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
      regular_events_for_location = regular_events.select {|e| e.schedulable_type == "Location"}
      if regular_events_for_location.any?
        regular_events_for_location.map do |reg_event| 
          ScheduleEvent.new(
            reg_event.day_from_week_start_at(start_date.wday),
            (start_date + days_after_start).strftime("%a").downcase,
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