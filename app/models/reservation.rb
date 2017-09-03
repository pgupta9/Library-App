class Reservation < ActiveRecord::Base
    belongs_to :slot
    belongs_to :user
    belongs_to :room
    belongs_to :library
    validates :slot_id, presence:true
    validates :room_id, presence:true
    validates :user_id, presence:true
    validates :reservation_date, presence:true
end
