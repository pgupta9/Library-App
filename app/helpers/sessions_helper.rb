module SessionsHelper
# Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
    # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  def logged_student?
    if !current_user.nil?
      return current_user.role == 'student'
    else return false 
    end
  end
  def logged_admin?
    if !current_user.nil?
      return (current_user.role == 'admin' || current_user.role == 'superadmin')
    else return false
    end
  end
  def logged_superadmin?
    if !current_user.nil?
      return current_user.role == 'superadmin'
    else return false
    end
  end
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
