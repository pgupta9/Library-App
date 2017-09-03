class ReservationsController < ApplicationController
  #before_action :logged_admin?, only: [:show, :edit, :update, :destroy, :index]
  #only: [:show, :edit, :update, :destroy]
  # GET /reservations
  # GET /reservations.json
  before_action :logged_in_user
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  def index
    if logged_admin?
    @reservations = Reservation.joins("INNER JOIN rooms ON rooms.id = reservations.room_id 
                                                   INNER JOIN users ON reservations.user_id = users.id
                                                   INNER JOIN slots ON reservations.slot_id = slots.id
                                                   INNER JOIN libraries ON rooms.library_id = libraries.id")
    else if logged_student?
    @reservations = Reservation.joins("INNER JOIN rooms ON rooms.id = reservations.room_id 
                                                   INNER JOIN users ON reservations.user_id = users.id
                                                   INNER JOIN slots ON reservations.slot_id = slots.id
                                                   INNER JOIN libraries ON rooms.library_id = libraries.id").where(user_id: session[:user_id])
          end
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    if logged_student?
    @reservations = Reservation.joins("INNER JOIN rooms ON rooms.id = reservations.room_id 
                                                   INNER JOIN users ON reservations.user_id = users.id
                                                   INNER JOIN slots ON reservations.slot_id = slots.id
                                                   INNER JOIN libraries ON rooms.library_id = libraries.id").
                                                   where(user_id: session[:user_id]).
                                                   where('reservation_date >= ?', DateTime.yesterday)
    else if logged_admin?
      @reservations = Reservation.joins("INNER JOIN rooms ON rooms.id = reservations.room_id 
                                                   INNER JOIN users ON reservations.user_id = users.id
                                                   INNER JOIN slots ON reservations.slot_id = slots.id
                                                   INNER JOIN libraries ON rooms.library_id = libraries.id").
                                                   where('reservation_date >= ?', DateTime.yesterday)
          end
    end
  end

  # GET /reservations/new
  def new
    @listrooms = Room.all
    @listlibraries = Library.all
    @listslot = Slot.select("id ,(to_char(start_time, 'HH24:MI') || ' - '|| (to_char(start_time + interval '2 hours', 'HH24:MI'))) as slot_time")
    #@listslot = Slot.select("id ,start_time as slot_time")
    if logged_student?
      @listuser = User.all.where(id: session[:user_id])
    else
      @listuser = User.all.where('role =?', 'student')
    end
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    
    @emailroom = Room.all.find(@reservation.room_id)
    @emaillibrary = Library.select("name").find(@emailroom.library_id)
    @emailemailid = User.all.find(session[:user_id])
    @emailslot = Slot.all.find(@reservation.slot_id)
    if (@emailslot.id >= 4 && @emailslot.id <=45)
      checkslot = [(@emailslot.id - 3),(@emailslot.id - 2),(@emailslot.id - 1),(@emailslot.id),(@emailslot.id + 1),(@emailslot.id + 2), (@emailslot.id + 3)]
    else if (@emailslot.id == 1)
          checkslot = [1, 2, 3, 4, 48, 47, 46]
        else if (@emailslot.id == 2)
          checkslot = [1, 2, 3, 4, 48, 47, 5]
          if (@emailslot.id == 3)
            checkslot = [1, 2, 3, 4, 48, 6, 5]
            if (@emailslot.id == 48)
              checkslot = [1, 2, 3, 45, 48, 47, 46]
              if (@emailslot.id == 47)
                checkslot = [1, 2, 44, 45, 48, 47, 46]
                if (@emailslot.id == 46)
                  checkslot = [1, 43, 44, 45, 48, 47, 46]
                end
              end
            end
          end
        end
        end
    end
    if logged_student?
        @anyres = Reservation.select('id').where('reservation_date=?', @reservation.reservation_date).where('user_id=?',@reservation.user_id)
      if (@anyres.count > 0)
        flash[:danger] = "You already have a booking for #{@reservation.reservation_date}"
        redirect_to new_reservation_path  and return
      end
    end
    @availres = Reservation.select('id').where('room_id=?', @emailroom.id).where('reservation_date=?', @reservation.reservation_date).where(slot_id: checkslot)
    if (@availres.count > 0)
      flash[:danger] = "room is not available for requested time"
      redirect_to new_reservation_path
    else
      respond_to do |format|
      if @reservation.save
        
        ReservationMailer.notify_email(@emailroom.room_number, @emaillibrary.name, @emailemailid.email,
        @reservation.reservation_date,
        @emailslot.start_time).deliver_now!
        
        emails=params[:emails]
        values=emails.split(",")
        values.each do |value|
          ReservationMailer.notify_email(@emailroom.room_number, @emaillibrary.name, value,
          @reservation.reservation_date,
          @emailslot.start_time).deliver_now!
        end
        
        format.html { redirect_to afterlogin_path, notice: 'Reservation was successfully created.' }
        #format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
      end
    
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    Reservation.find(params[:id]).destroy
    #@reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservation_url(1), notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      #@reservation = Reservation.find(params[:id])
      @reservations = Reservation.joins("INNER JOIN rooms ON rooms.id = reservations.room_id 
                                                   INNER JOIN users ON reservation.user_id = users.id").where(user_id: session[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:room_id, :user_id, :slot_id, :reservation_date)
    end
end