class Api::V1::CurrentUserController < ApplicationController
  before_action :doorkeeper_authorize!
  def index 
    user = UserSerializer.new(current_user, include: [:provider_oauth_tokens]).serializable_hash
    render json: user[:data][:attributes].merge(services: user[:included].map{|pot| pot[:attributes]})
  end
end
