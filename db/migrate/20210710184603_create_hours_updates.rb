class CreateHoursUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :hours_updates do |t|
      t.json :update_results
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
