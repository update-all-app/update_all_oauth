class Api::V1::CurrentUserController < ApplicationController
  before_action :doorkeeper_authorize!
  def index 
    render json: current_user
  end
end
