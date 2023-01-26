class CreateIrregularEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :irregular_events do |t|
      t.integer :status
      t.datetime :start_time
      t.datetime :end_time
      t.bigint :schedulable_id
      t.string :schedulable_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
