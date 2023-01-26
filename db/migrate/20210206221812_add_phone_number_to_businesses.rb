class AddPhoneNumberToBusinesses < ActiveRecord::Migration[6.1]
  def change
    add_column :businesses, :phone_number, :string
  end
end
