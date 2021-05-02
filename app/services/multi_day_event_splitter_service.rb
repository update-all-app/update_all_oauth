class MultiDayEventSplitterService 
  def self.process(irregular_event)
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
end