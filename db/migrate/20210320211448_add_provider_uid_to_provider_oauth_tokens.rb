class AddProviderUidToProviderOauthTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :provider_oauth_tokens, :provider_uid, :string
  end
end
