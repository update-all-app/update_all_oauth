class Api::V1::HoursSummaryController < ApplicationController
  before_action :set_location, :set_business
  # user, location, start_date, end_date
  # change initialize to accept user, location, start_date, end_date
  # move regular_events and irregular_events into service (as instance variables?)
  def index 
    render json: HoursSummaryService.new(
      user: current_user, 
      location: @location,
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