class Room < ActiveRecord::Base
    belongs_to :library
    has_many :reservations
    validates :room_number, presence:true
    validates :size, presence:true
    validates :library_id, presence:true
end
