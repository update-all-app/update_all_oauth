class AddPaymentStatusToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :payment_status_current, :boolean
  end
end
