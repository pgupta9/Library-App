class AddLibraryIdToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :library_id, :integer
  end
end
