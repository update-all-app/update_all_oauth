class IrregularEventValueObject 
  attr_accessor :status, :start_time, :end_time, :schedulable_type

  def initialize(status:, start_time:, end_time:, schedulable_type:)
    @status = status
    @start_time = start_time
    @end_time = end_time
    @schedulable_type = schedulable_type
  end

  def days_from_start_date(start_date)
    (start_time - start_date).to_i
  end
end