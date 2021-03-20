class RenameExpiresInToExpiresAtInProviderOauthTokens < ActiveRecord::Migration[6.1]
  def change
    remove_column :provider_oauth_tokens, :expires_in
    add_column :provider_oauth_tokens, :expires_at, :datetime
  end
end
