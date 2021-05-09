class Api::V1::IrregularEventsController < ApplicationController
  before_action :set_irregular_event, only: [:show, :update, :destroy]
  before_action :set_business
  before_action :set_location

  # GET /irregular_events
  def index
    if @location
      @irregular_events = @location.irregular_events
    elsif @business
      @irregular_events = @business.irregular_events
    else
      @irregular_events = current_user.irregular_events
    end

    render json: @irregular_events
  end

  # GET /irregular_events/1
  def show
    render json: @irregular_event
  end

  # POST /irregular_events
  def create
    @irregular_event = current_user.irregular_events.build(irregular_event_params)
    if @location
      @irregular_event.schedulable = @location
    elsif @business
      @irregular_event.schedulable = @business
    end
    split_events = MultiDayEventSplitterService.process_create(@irregular_event)
    if split_events.all? { |e| e.save }
      render json: split_events, status: :created
    else
      render json: @irregular_event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /irregular_events/1
  def update
    if @irregular_event.update(irregular_event_params)
      split_events = MultiDayEventSplitterService.process_update(@irregular_event)
      if split_events.all? { |e| e.save }
        render json: split_events, status: :ok
      else
        render json: @irregular_event.errors, status: :unprocessable_entity
      end
    else
      render json: @irregular_event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /irregular_events/1
  def destroy
    @irregular_event.destroy
    render json: @irregular_event
  end

  private
    def set_location
      @location = Location.find_by_id(params[:location_id])
    end

    def set_business
      @business = Business.find_by_id(params[:business_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_irregular_event
      @irregular_event = current_user.irregular_events.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def irregular_event_params
      params.require(:irregular_event).permit(:status, :start_time, :end_time, :schedulable_id, :schedulable_type, :user_id)
    end
end
