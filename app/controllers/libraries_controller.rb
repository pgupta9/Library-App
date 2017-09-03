class LibrariesController < ApplicationController
  before_action :set_library, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  # GET /libraries
  # GET /libraries.json
  def index
    if logged_admin?
        @libraries = Library.all
    else
        flash[:danger] = "You must be logged in as admin"
        redirect_to root_url
    end
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
    if logged_admin?
    else
        flash[:danger] = "You must be logged in as admin"
        redirect_to root_url
    end
  end

  # GET /libraries/new
  def new
    if logged_admin?
       @library = Library.new
    else
        flash[:danger] = "You must be logged in as admin"
        redirect_to root_url
    end
  end

  # GET /libraries/1/edit
  def edit
    if logged_admin?
    else
        flash[:danger] = "You must be logged in as admin"
        redirect_to root_url
    end
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Library was successfully created.' }
        format.json { render :show, status: :created, location: @library }
      else
        format.html { render :new }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libraries/1
  # PATCH/PUT /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to @library, notice: 'Library was successfully updated.' }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.json
  def destroy
    @library.destroy
    respond_to do |format|
      format.html { redirect_to libraries_url, notice: 'Library was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      if logged_admin?
        @library = Library.find(params[:id])
      else
        flash[:danger] = "You must be logged in as admin"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_params
      params.require(:library).permit(:name)
    end
end
