class AddUserReferenceToBusinesses < ActiveRecord::Migration[6.1]
  def change
    add_reference :businesses, :user, null: false, foreign_key: true
  end
end
