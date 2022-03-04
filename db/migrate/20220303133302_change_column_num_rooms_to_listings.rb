class ChangeColumnNumRoomsToListings < ActiveRecord::Migration[6.0]
  def change
    change_column :listings, :num_rooms, :integer, default: "0"
  end
end
