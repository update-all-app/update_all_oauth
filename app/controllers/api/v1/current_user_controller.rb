class Api::V1::CurrentUserController < ApplicationController
  before_action :doorkeeper_authorize!
  def index 
    render json: UserSerializerService.call(current_user)
  end
end
