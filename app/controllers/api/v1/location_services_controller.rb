class Api::V1::LocationServicesController < ApplicationController
  before_action :set_location_service, only: [:show, :update, :destroy]

  # GET /location_services
  def index
    @location_services = LocationService.all

    render json: @location_services
  end

  # GET /location_services/1
  def show
    render json: @location_service
  end

  # POST /location_services
  def create
    @location_service = LocationService.new(location_service_params)

    if @location_service.save
      render json: @location_service, status: :created
    else
      render json: @location_service.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /location_services/1
  def update
    if @location_service.update(location_service_params)
      render json: @location_service
    else
      render json: @location_service.errors, status: :unprocessable_entity
    end
  end

  # DELETE /location_services/1
  def destroy
    @location_service.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_service
      @location_service = LocationService.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_service_params
      params.require(:location_service).permit(:location_id, :provider_oauth_token_id)
    end
end
