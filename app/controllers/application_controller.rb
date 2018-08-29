class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_admin_user

   def current_admin_user
  	 current_admin_user ||= AdminUser.find_by(id: cookies.signed[:admin_user_id]) if cookies.signed[:admin_user_id]
   end

    def require_admin_user
  		redirect_to new_admin_session_path unless current_admin_user.present?		
    end
end
