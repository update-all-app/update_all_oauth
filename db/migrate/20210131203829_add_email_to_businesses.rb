class AddEmailToBusinesses < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :email, :string
  end
end
