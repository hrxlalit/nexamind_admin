class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  helper_method :current_admin_user

  def render_message code,message
    render :json => {:responseCode => code,:responseMessage => message}
  end
    
  def is_json?
    if request.format != :json
      render :json => {
        :responseCode => 400,
        :responseMessage => "The request must be json."
      }
    end
  end
 
  def find_user
    if request.headers[:AUTHTOKEN].present?
      user_token = request.headers[:AUTHTOKEN]
      @current_user = User.find_by(access_token: user_token)
      unless @current_user
        return render_message 403,"Oops! Your token is expired."
      end
      if @current_user.status.eql?(0)
        return render_message 405,"User is blocked or deleted."
      elsif @current_user.status.eql?(2)
        return render_message 407,"Sorry! User is not verified."
      end
    else
      render_message 402, "Sorry! You are not an authenticated user." unless @current_user
    end
  end 

  def find_store
    if request.headers[:AUTHTOKEN].present?
      user_token = request.headers[:AUTHTOKEN]
      @current_store = Store.find_by(access_token: user_token)
      unless @current_store
        return render_message 403,"Oops! Store token is expired."
      end
      if @current_store.status.eql?(0)
        return render_message 405,"Store is blocked or deleted."
      elsif @current_store.status.eql?(2)
        return render_message 407,"Sorry! Store is not verified."
      end
    else
      render_message 402, "Sorry! store is not authenticated." unless @current_store
    end
  end 

  def current_admin_user
  	current_admin_user ||= AdminUser.find_by(id: cookies.signed[:admin_user_id]) if cookies.signed[:admin_user_id]
  end

  def require_admin_user
  	redirect_to new_admin_session_path unless current_admin_user.present?		
  end
end
