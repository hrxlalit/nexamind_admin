require 'will_paginate/array'
class Admin::UsersController < ApplicationController
  before_action :require_admin_user
  before_action :find_user, except: [:index, :vendor_list]

  def index
    if params[:search].present? && params[:gender].present? && params[:status].present?
      @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")}).and({status: params[:status]},{gender: params[:gender]})
      @users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif params[:gender].present? && params[:gender] != ""
      @search = User.where({gender: params[:gender]}) 
      @users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif params[:status].present? && params[:status] != ""
      @search = User.where({status: params[:status]}) 
      @users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10) 
    elsif params[:search].present? && params[:search] != ""
      @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")}) 
      @users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10) 
    else
      @users = User.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def user_status
   if params[:status] == "1" 
      @user.update_attributes(status: 1)
      redirect_to  request.referer,notice: "User's account activated successfully."
   elsif params[:status] == "0" 
      @user.update_attributes(status: 0)
      redirect_to  request.referer, notice: "User's account blocked successfully."
   end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
			redirect_to admin_users_path, notice: 'User updated Successfully.'
		else
      flash[:error] = @user.errors.full_messages.first
			render :edit
		end
  end

  def show
    
  end

  def destroy
    if @user.destroy
      redirect_to  admin_users_path
    else
      flash[:error] = @user.errors.full_messages.first
      redirect_to  admin_users_path
    end
  end


  private
  def find_user
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path unless @user
  end

  def user_params
		params.permit(:email,:password,:name,:mobile,:address,:status,:gender, :country, :city, :code)
	end
end
