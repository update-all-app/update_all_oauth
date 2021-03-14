class Api::V1::ProviderOauthTokensController < ApplicationController
  # before_action :set_provider_oauth_token, only: [:show, :update, :destroy]

  # # GET /provider_oauth_tokens
  # def index
  #   @provider_oauth_tokens = ProviderOauthToken.all

  #   render json: @provider_oauth_tokens
  # end

  # # GET /provider_oauth_tokens/1
  # def show
  #   render json: @provider_oauth_token
  # end

  # POST /provider_oauth_tokens
  def create
    @provider_oauth_token = current_user.provider_oauth_tokens.build(provider_oauth_token_params)

    @provider_oauth_token.retrieve
    if @provider_oauth_token.save
      render json: @provider_oauth_token, status: :created
    else
      render json: @provider_oauth_token.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /provider_oauth_tokens/1
  # def update
  #   if @provider_oauth_token.update(provider_oauth_token_params)
  #     render json: @provider_oauth_token
  #   else
  #     render json: @provider_oauth_token.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /provider_oauth_tokens/1
  # def destroy
  #   @provider_oauth_token.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_provider_oauth_token
    #   @provider_oauth_token = ProviderOauthToken.find(params[:id])
    # end

    # Only allow a list of trusted parameters through.
    def provider_oauth_token_params
      params.require(:provider_oauth_token).permit(:provider, :exchange_token)
    end
end
