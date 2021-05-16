class CreateLocationServices < ActiveRecord::Migration[6.1]
  def change
    create_table :location_services do |t|
      t.references :location, null: false, foreign_key: true
      t.references :provider_oauth_token, null: false, foreign_key: true

      t.timestamps
    end
  end
end
