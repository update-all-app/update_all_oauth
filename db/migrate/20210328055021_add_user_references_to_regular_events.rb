class AddUserReferencesToRegularEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :regular_events, :user, null: false, foreign_key: true
  end
end
