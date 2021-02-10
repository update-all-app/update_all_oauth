class Api::V1::BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :update, :destroy]

  # GET /businesses
  def index
    @businesses = current_user.businesses
    render json: @businesses.to_json(include: [:locations])
  end

  # GET /businesses/1
  def show
    render json: @business
  end

  # POST /businesses
  def create 
    @business = current_user.businesses.build(business_params)
    if @business.save
      render json: @business.to_json(include: [:locations]), status: :created
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
      @business = current_user.businesses.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def business_params
      params.require(:business).permit(:name, :email_address, :phone_number, locations_attributes: [:address_line_1, :address_line_2, :city, :state, :zipcode, :country, :phone_number])
    end
end
