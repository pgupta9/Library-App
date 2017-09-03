class Slot < ActiveRecord::Base
    has_many :reservations
    validates :start_time, presence:true
end
