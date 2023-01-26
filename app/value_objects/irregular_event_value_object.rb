class IrregularEventValueObject 
  attr_accessor :status, :start_time, :end_time, :schedulable_type

  def initialize(status:, start_time:, end_time:, schedulable_type:)
    @status = status
    @start_time = start_time
    @end_time = end_time
    @schedulable_type = schedulable_type
  end


  def start_time_24hr
    start_time.strftime('%H:%M')
  end

  def end_time_24hr
    end_time.strftime('%H:%M')
  end
end