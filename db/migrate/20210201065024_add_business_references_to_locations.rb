class AddBusinessReferencesToLocations < ActiveRecord::Migration[6.1]
  def change
    add_reference :locations, :business, null: false, foreign_key: true
  end
end
