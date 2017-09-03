class ReservationMailer < ApplicationMailer
 default from: "noreplycsc517@gmail.com"
 
 def notify_email (room, library_name, email, date, slot)
     @number = room
     @library = library_name
     @date = date
     @slot = slot
     mail(to: email,subject: 'Booking Confirmation')
 end
end
