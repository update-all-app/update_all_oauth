class AddPageDataToProviderOauthTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :provider_oauth_tokens, :page_data, :json
  end
end
