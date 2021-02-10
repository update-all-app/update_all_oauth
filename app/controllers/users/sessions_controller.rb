# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  respond_to :json
  skip_before_action :doorkeeper_authorize!

  # GET /resource/sign_in
  # def new
  #   super
  # end

  def refresh 
    params["token"] = request.headers.fetch(:authorization).try(:split," ").try(:last)
    @token ||= Doorkeeper.config.access_token_model.by_token(params["token"]) ||
               Doorkeeper.config.access_token_model.by_refresh_token(params["token"])
    if @token 
      @user = User.find_by_id(@token.resource_owner_id)
      @new_token = TokenService.new(user: resource, previous_refresh_token: @token.refresh_token).get_token
      @token.revoke
      render json: {
        user: @user, 
        token: @new_token
      }, status: :ok
    else
      render json: {
        message: "Couldn't refresh the token"
      }, status: :unprocessable_entity
    end
  end

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

  def respond_to_on_destroy
    if user_signed_in? 
      params["token"] = request.headers.fetch(:authorization).try(:split," ").try(:last)
      @token ||= Doorkeeper.config.access_token_model.by_token(params["token"]) ||
                 Doorkeeper.config.access_token_model.by_refresh_token(params["token"])
      @token.revoke
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: { 
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
