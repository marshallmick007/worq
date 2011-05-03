class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
 

protected

  def pre_auth?
    respond_to do |format|
      format.html { logged_in? }
      format.json { authenticate? }
    end
  end

  # add before_filter :logged_in? in controllers to protect
  def logged_in?
    unless session[:user_id]
      flash[:notice] = "You need to log in first."
      redirect_to root_path
      return false
    else
      return true
    end
  end


private

  def authenticate?
    authenticate_or_request_with_http_basic do |user_name, password| 
      user = User.authenticate(user_name, password)
      if user
        session[:user_id] = user.id
        true
      else
        session[:user_id] = nil
        false
      end
    end
  end
  

  def current_user
    # ||= 'Or Equals, or null coalesce
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
end
