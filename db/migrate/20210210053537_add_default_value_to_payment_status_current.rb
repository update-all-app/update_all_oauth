class AddDefaultValueToPaymentStatusCurrent < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :payment_status_current, :boolean, deafult: false
  end
end
