class Admin::HomeController < ApplicationController
  before_action :require_admin_user, except: [:forget_password, :reset_password]
  # before_action :find_admin_user, except: [:forget_password, :change_password]

  def index
    
  end

  def edit
  end

  def update
    
  end

  def show
  end

  def forget_password
  end

  def reset_password
    @admin_user = AdminUser.find_by(email: params[:admin_user][:email])
    if @admin_user.present?
      @password = SecureRandom.hex(5)
      @admin_user.update_attributes(password: @password)
      UserMailer.forget_password(@admin_user, @password).deliver_now
      redirect_to admin_home_index_path
      flash[:notice] = "If you have entered correct email, you will receive your password to email."
    else
      redirect_to forget_password_admin_home_index_path 
      flash[:error] = "Invalid Email, Please try again."
    end
  end
end