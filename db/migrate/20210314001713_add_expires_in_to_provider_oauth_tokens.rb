class AddExpiresInToProviderOauthTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :provider_oauth_tokens, :expires_in, :integer
  end
end
