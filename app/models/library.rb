class Library < ActiveRecord::Base
    has_many :rooms
    has_many :reservations
    validates :name, presence:true
end
