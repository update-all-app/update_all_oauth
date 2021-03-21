class ProviderOauthTokenSerializer
  include JSONAPI::Serializer
  attributes :provider, :provider_uid, :label
end
