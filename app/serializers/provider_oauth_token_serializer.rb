class ProviderOauthTokenSerializer
  include JSONAPI::Serializer
  attributes :id, :provider, :provider_uid, :label
end
