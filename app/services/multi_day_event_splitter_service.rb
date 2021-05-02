class MultiDayEventSplitterService 
  def self.process_create(irregular_event)
    start_date = irregular_event.start_time.to_date
    end_date = irregular_event.end_time.to_date
    if irregular_event.status == "closed" && start_date != end_date
      (start_date..end_date).map do |day|
        irregular_event.clone(
          status: "closed", 
          start_time: UtcDatetimeService.utc_from_date(day, start_of_day: true),
          end_time: UtcDatetimeService.utc_from_date(day, start_of_day: false)
        )
      end
    else 
      [irregular_event]
    end
  end

  def self.process_update(irregular_event)
    start_date = irregular_event.start_time.to_date
    end_date = irregular_event.end_time.to_date
    if irregular_event.status == 'closed' && start_date != end_date
      irregular_event.end_time = UtcDatetimeService.utc_from_date(start_date, start_of_day: false)
      events = (start_date.next_day..end_date).map do |day|
        irregular_event.clone(
          status: 'closed',
          start_time: UtcDatetimeService.utc_from_date(day, start_of_day: true),
          end_time: UtcDatetimeService.utc_from_date(day, start_of_day: false)
        )
      end
      [irregular_event] + events
    else
      [irregular_event]
    end
  end
end