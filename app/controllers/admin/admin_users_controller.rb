class Admin::AdminUsersController < ApplicationController
	before_action :require_admin_user, except: [:new, :create]
  before_action :find_admin_user, except: [:index, :new, :create]

  def index
  end

  def new
  end

  def edit
  end

  def update
    if @admin_user.update_attributes(admin_user_params)
      if @admin_user.try(:image).present?
        @admin_user.image.update_attributes(file: params[:admin_user][:file])
      else
        @admin_user.create_image(file: params[:admin_user][:file])
      end
      redirect_to edit_admin_admin_user_path
      flash[:notice] = 'Profile updated Successfully.'       
    else
      flash[:notice] = @admin_user.errors.full_messages.first
      render :edit
    end
  end

  def show
  end

  def change_password
  end

  def update_password
     # binding.pry
    if @admin_user.valid_password?params[:admin_user][:old_password]
      if params[:admin_user][:new_password].eql?(params[:admin_user][:confirm_password])
        @admin_user.update_attributes(password: params[:admin_user][:new_password])
        redirect_to admin_users_path
        flash[:notice] = "Your Password changed successfully."
      else
        redirect_to change_password_admin_admin_user_path
        flash[:error] = "Confirm Password doen't match with Password."
      end
    else
      flash[:error] = "Your current password is incorrect, it's required to change the Password."
      redirect_to change_password_admin_admin_user_path#, alert: "Error"
      
    end
  end

  private
  def find_admin_user
    @admin_user = AdminUser.find_by(id: params[:id])
    redirect_to admin_home_index_path unless @admin_user
  end
   def admin_user_params
    params.require(:admin_user).permit(:email, :name, :password)
  end
end
