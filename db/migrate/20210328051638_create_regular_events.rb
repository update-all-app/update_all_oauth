class CreateRegularEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :regular_events do |t|
      t.integer :day_of_week
      t.string :start_time
      t.string :end_time
      t.bigint :schedulable_id
      t.string :schedulable_type

      t.timestamps
    end
  end
end
