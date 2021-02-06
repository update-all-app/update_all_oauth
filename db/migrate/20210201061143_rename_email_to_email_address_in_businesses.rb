class RenameEmailToEmailAddressInBusinesses < ActiveRecord::Migration[6.1]
  def change
    rename_column :businesses, :email, :email_address
  end
end
