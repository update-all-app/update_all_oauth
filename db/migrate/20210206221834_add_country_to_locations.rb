class AddCountryToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :country, :string
  end
end
