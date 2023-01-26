class AddLabelToProviderOauthTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :provider_oauth_tokens, :label, :string
  end
end
