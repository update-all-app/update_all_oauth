# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  respond_to :json
  skip_before_action :doorkeeper_authorize!

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create 
  #   super
  # end 

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # only called when credentials are accurate
  def sign_in(resource_name, resource)
    puts resource.inspect
    @token = TokenService.new(user: resource).get_token
  end

  def respond_with(resource,_opts = {})
    if resource.persisted?
      render json: {
        user: resource,
        token: @token, 
        message: "Logged in Successfully"
      }, status: :ok
    else
      render json: {
        message: "Invalid Email or Password"
      }, status: :unauthorized
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
