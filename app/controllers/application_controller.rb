class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    render json: "Record not found", status: :not_found
  end

  # helper method to access the current user from the token
  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.try(:[],:resource_owner_id))
  end
end
