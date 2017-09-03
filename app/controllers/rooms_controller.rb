class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    if logged_admin?
      @rooms = Room.joins("INNER JOIN libraries ON rooms.library_id = libraries.id")
    else
      flash[:danger] = "You must be logged in as admin"
      redirect_to root_url
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    if logged_admin?
    else
      flash[:danger] = "You must be logged in as admin"
      redirect_to root_url
    end
  end

  # GET /rooms/new
  def new
    if logged_admin?
      @room = Room.new
      @listlibraries = Library.all
    else
      flash[:danger] = "You must be logged in as admin"
      redirect_to root_url
    end
  end

  # GET /rooms/1/edit
  def edit
    if logged_admin?
      @room = Room.new
    else
      flash[:danger] = "You must be logged in as admin"
      redirect_to root_url
    end
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @availres = Reservation.all.where(room_id: params[:id]).where('reservation_date >= ?', DateTime.yesterday)
    if (@availres.count > 0)
      flash[:danger] = "Room has future reservations. Please delete the reservations and try deleting the room."
      redirect_to afterlogin_path
    else
      @room.destroy
      respond_to do |format|
        format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:library_id, :room_number, :size)
    end
end
