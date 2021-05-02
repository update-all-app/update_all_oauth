class UtcDatetimeService
  def self.strip_to_utc(datetime)
    DateTime.new(
      datetime.year, 
      datetime.month, 
      datetime.day, 
      datetime.hour, 
      datetime.min
    )
  end

  def self.utc_from_date(date, start_of_day: true)
    DateTime.new(
      date.year,
      date.month,
      date.day,
      start_of_day ? 00 : 23,
      start_of_day ? 00 : 59
    )
  end

end