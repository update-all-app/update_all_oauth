class AddPageIdToLocationServices < ActiveRecord::Migration[6.1]
  def change
    add_column :location_services, :page_id, :string
  end
end
