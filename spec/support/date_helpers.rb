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
def beginning_of_week
  DateTime.now.beginning_of_week
end

def end_of_week
  DateTime.now.end_of_week
end

def day_and_time_this_week(day, time)
  day.downcase!
  raise StandardError.new("Not a valid Day") unless DAYS.keys.include?(day)
  raise StandardError.new("time must be in military format HH:MM") unless time.match(/\A\d\d?:\d{2}\z/)
  hours, minutes = time.split(':').map(&:to_i)
  raise StandardError.new("Hours must be in military time (between 0 and 24") unless 0 <= hours && hours < 24
  raise StandardError.new("Minutes must be between 0 and 60") unless 0 <= minutes && minutes < 60
  beginning_of_week + DAYS[day].days + hours.hours + minutes.minutes
end
