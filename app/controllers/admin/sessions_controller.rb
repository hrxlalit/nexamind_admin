class Admin::SessionsController < ApplicationController
  def new
    redirect_to admin_users_path if current_admin_user.present?
  end

  def create
    if @admin_user = AdminUser.find_by(email: params[:session][:email])
      if @admin_user && @admin_user.valid_password?(params[:session][:password])
          @admin_user.update_attributes(sign_in_count: @admin_user.sign_in_count+1, last_sign_in_at: Time.current)
          binding.pry
          if params[:session][:remember_me].eql?("1")
            cookies.signed[:admin_user_id] = { value: @admin_user.id.to_s, expires: 2.weeks.from_now}
          else
            # expires at the end of the browser session
            cookies.signed[:admin_user_id] = @admin_user.id.to_s
          end
          flash[:notice] = "You have successfully logged In."
          redirect_to admin_users_path
      else
     		redirect_to new_admin_session_path
        flash[:error] = "Invalid Email or Password"
      end      
    else
      redirect_to new_admin_session_path
      flash[:error] = "Invalid Email, Please try again."
    end
	end

	def destroy
    session[:admin_user_id] = nil
    cookies.delete :admin_user_id
    flash[:notice] = "You have successfully logged out."
    redirect_to new_admin_session_path
	end

  # def destroy_all_sessions
  #   if cookies.signed[:admin_user_id].present?
  #     cookies.signed[:admin_user_id] = nil
  #     render json: {signed_out: 1}
  #     flash[:error] = "Please change network to Ropsten ethereum network"
  #   else
  #     render json: {signed_out: 0}
  #   end
  # end
end