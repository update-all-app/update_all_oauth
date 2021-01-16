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
  def create    
    if user = User.authenticate(params[:email], params[:password])
      uri = URI("http://#{request.env['HTTP_HOST']}/oauth/token")
      res = Faraday.post(uri, {
        grant_type: 'password',
        email: params[:email],
        password: params[:password],
        client_id: ENV["REACT_CLIENT_UID"],
        client_secret: ENV["REACT_CLIENT_SECRET"]
      })
      @json = JSON.parse(res.body)
      render json: {
        token: @json,
        user: user,
        message: "Logged in successfully"
      }, status: :ok
    else
      render json: {
        error: "Inalid Email Password combination."
      }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def respond_with(resource, _opts = {})
    render json: @json
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
