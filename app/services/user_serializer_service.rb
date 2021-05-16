class UserSerializerService
  def self.call(current_user)
    user = UserSerializer.new(current_user, include: [:provider_oauth_tokens]).serializable_hash
    user[:data][:attributes].merge(services: user[:included].map{|pot| pot[:attributes]})
  end
end