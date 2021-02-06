class Api::V1::BusinessesController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_business, only: [:show, :update, :destroy]

  # GET /businesses
  def index
    @businesses = Business.all
    render json: @businesses
  end

  # GET /businesses/1
  def show
    render json: @business
  end

  # POST /businesses
  def create 
    @business = current_user.businesses.build(business_params)
    if @business.save
      render json: @business, status: :created
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /businesses/1
  def update
    if @business.update(business_params)
      render json: @business
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  # DELETE /businesses/1
  def destroy
    @business.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def business_params
      params.require(:business).permit(:name, :email_address, :phone_number, locations_attributes: [:address_line_1, :address_line_2, :city, :state, :zipcode, :country, :phone_number])
    end
end
