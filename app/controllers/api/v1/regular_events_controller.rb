class Api::V1::RegularEventsController < ApplicationController
  before_action :set_regular_event, only: [:show, :update, :destroy]
  before_action :set_business
  before_action :set_location

  # GET /regular_events
  def index
    if @location
      @regular_events = @location.regular_events
    elsif @business
      @regular_events = @business.regular_events
    else
      @regular_events = current_user.regular_events
    end
    
    render json: @regular_events
  end

  # POST /regular_events
  def create
    @regular_event = current_user.regular_events.build(regular_event_params)
    if @location
      @regular_event.schedulable = @location
    elsif @business
      @regular_event.schedulable = @business
    end
    if @regular_event.save
      render json: @regular_event, status: :created
    else
      render json: @regular_event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /regular_events/1
  def update
    if @regular_event.update(regular_event_params)
      render json: @regular_event
    else
      render json: @regular_event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /regular_events/1
  def destroy
    @regular_event.destroy
    render json: @regular_event
  end

  private

    def set_location
      @location = Location.find_by_id(params[:location_id])
    end

    def set_business
      @business = Business.find_by_id(params[:business_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_regular_event
      @regular_event = current_user.regular_events.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def regular_event_params
      params.require(:regular_event).permit(:day_of_week, :start_time, :end_time, :schedulable_id, :schedulable_type)
    end
end
