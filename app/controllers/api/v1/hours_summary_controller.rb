class Api::V1::HoursSummaryController < ApplicationController
  before_action :set_location, :set_business, 
  def index 
    regular_events = current_user.regular_events.by_location(@location).map do |re|
      RegularEventValueObject.new(
        day_of_week: re.day_of_week,
        start_time: re.start_time,
        end_time: re.end_time,
        schedulable_type: re.schedulable_type
      )
    end
    irregular_events = current_user.irregular_events.between(params[:start_date], params[:end_date]).by_location(@location).map do |ie|
      IrregularEventValueObject.new(
        status: ie.status,
        start_time: ie.start_time,
        end_time: ie.end_time,
        schedulable_type: ie.schedulable_type
      )
    end

    render json: HoursSummaryService.new(
      regular_events: regular_events, 
      irregular_events: irregular_events,
      start_date: Date.parse(params[:start_date]), 
      end_date: Date.parse(params[:end_date])
    ).call
  end

  private 

  def set_location
    @location = current_user.locations.find_by_id(params[:id])
  end

  def set_business
    @business = @location.business
  end

end