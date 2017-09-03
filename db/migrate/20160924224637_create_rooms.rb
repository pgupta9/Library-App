class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :library_id
      t.integer :room_number
      t.integer :size

      t.timestamps null: false
    end
  end
end
