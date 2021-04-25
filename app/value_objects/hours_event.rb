class HoursEvent 
  attr_accessor :status, :start_time, :end_time, :schedulable_type, :event_type, :status
  def initialize(attrs)
    attrs.each {|method, arg| self.send("#{method}=", arg)}
  end
end