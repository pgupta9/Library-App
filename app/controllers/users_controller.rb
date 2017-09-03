class UsersController < ApplicationController
  #before_action :logged_in_user
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  def logged_in_admin
    unless logged_admin?
      flash[:danger] = "Please log in as admin"
      redirect_to login_url
    end
  end
  def show
    if logged_in?
      #@user = User.find(params[:id])
      @user = User.find(session[:user_id])
    else
      flash[:danger] = "You must be logged in"
      redirect_to root_url
    end
  end
  def destroy
    @availableres = Reservation.all.where(user_id: params[:id]).where('reservation_date >= ?', DateTime.yesterday)
    if (@availableres.count > 0)
      flash[:danger] = "User has future reservations. Please delete the reservations and try deleting the user."
      redirect_to afterlogin_path
    else
      User.find(params[:id]).destroy
      flash[:danger] = "Deleted!"
      redirect_to afterlogin_path
    end
    
  end
  def listadmins
    logged_in_admin
    @listadmins = User.all.where('role=?', 'admin').where('id!=?', session[:user_id])
  end
  def listusers
    logged_in_admin
    @listusers = User.all.where('role=?', 'student')
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
     if @user[:role] ==nil
      if logged_admin?
        @user[:role] = 'admin'
      else
        @user[:role] = 'student'
      end
     end
    if @user.save
      if logged_in?
        flash[:success] = "New account created"
        @user = User.find(session[:user_id])
        #redirect_to @user
        redirect_to afterlogin_path
      else
        log_in @user
        flash[:success] = "Welcome to Library Reservation Service!"
        redirect_to afterlogin_path
      end
    else
      render 'new'
    end
  end
  
  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated!"
      redirect_to afterlogin_path
    else
      render 'show'
      #flash[:danger] = "Unkown Error: couldnot update profile"
      #redirect_to afterlogin_path
    end
  end
  
  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :role)
  end
end
