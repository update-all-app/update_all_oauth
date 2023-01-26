class Api::V1::HoursUpdatesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_hours_update, only: [:show, :update, :destroy]
  before_action :set_location

  # GET /locations/:location_id/hours_updates
  def index
    @hours_updates = @location.hours_updates

    render json: @hours_updates
  end

  # GET /locations/:location_id/hours_updates/1
  def show
    render json: @hours_update
  end

  # POST /locations/:location_id/hours_updates
  def create
    update_results = UpdateHoursService.new(@location).call
    @hours_update = @location.hours_updates.build(update_results: update_results)

    # error case doesn't make sense here yet as there's nothing that could 
    # trigger it. We may want to consider having some distinction here
    # if one of the services fails to update? (Handle errors in service)
    if @hours_update.save
      render json: @hours_update, status: :created
    else
      render json: @hours_update.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /locations/:location_id/hours_updates/1
  def update
    if @hours_update.update(hours_update_params)
      render json: @hours_update
    else
      render json: @hours_update.errors, status: :unprocessable_entity
    end
  end

  # DELETE /locations/:location_id/hours_updates/1
  def destroy
    @hours_update.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hours_update
      @hours_update = HoursUpdate.find(params[:id])
    end

    def set_location
      @location = current_user.locations.find(params[:location_id])
    end

    # Only allow a list of trusted parameters through.
    def hours_update_params
      params.require(:hours_update).permit()
    end
end
