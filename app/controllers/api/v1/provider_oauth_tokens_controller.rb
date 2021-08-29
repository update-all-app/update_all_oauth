class Api::V1::ProviderOauthTokensController < ApplicationController
  before_action :set_provider_oauth_token, only: [:destroy]

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
    @provider_oauth_token = current_user.provider_oauth_tokens.find_or_create_by(existing_token_params)
    require 'google/api_client/client_secrets'
    require "google/apis/mybusinessplaceactions_v1"

    # Create a client object
    client = Google::Apis::MybusinessplaceactionsV1::MyBusinessPlaceActionsService.new

    # use https://github.com/googleapis/signet to from code to access token
    CLIENT_SECRETS = Google::APIClient::ClientSecrets.load
    authorization = CLIENT_SECRETS.to_authorization

    # You can then use this with an API client, e.g.:
    client.authorization = authorization
    byebug
    @provider_oauth_token.retrieve(short_term_creds)
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
  def destroy
    @provider_oauth_token.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_oauth_token
      @provider_oauth_token = current_user.provider_oauth_tokens.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def short_term_creds
      params.require(:provider_oauth_token).permit(:exchange_token, :code)
    end

    def existing_token_params
      params.require(:provider_oauth_token).permit(:provider, :provider_uid)
    end
end
