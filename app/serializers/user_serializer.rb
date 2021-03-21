class UserSerializer
  include JSONAPI::Serializer
  has_many :provider_oauth_tokens
  
  attributes :id, :name, :email
  # add this when we get email confirmation finished
  # attribute :confirmed do |user|
  #   !!user.confirmed_at
  # end
end
