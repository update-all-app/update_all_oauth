class CreateProviderOauthTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :provider_oauth_tokens do |t|
      t.string :provider
      t.string :access_token
      t.string :refresh_token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
