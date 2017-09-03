class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :room_id
      t.integer :user_id
      t.integer :slot_id
      t.date :reservation_date

      t.timestamps null: false
    end
  end
end
