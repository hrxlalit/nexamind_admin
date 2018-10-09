require 'will_paginate/array'
class Admin::UsersController < ApplicationController
  before_action :require_admin_user
  before_action :find_user, except: [:index, :vendor_list]

  def index
    if params[:search].present?
      if params[:gender].present? && !params[:status].present? == false
      @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(gender: params[:gender])
      elsif params[:status].present? && !params[:gender].present?
      @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(status: params[:status])
      elsif params[:status].present? && params[:gender].present?
      @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(gender: params[:gender], status: params[:status])
      else
          
      @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")})
  end
    else
    @search = User.all
    end
    @users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 5)
  end

  def user_status
   if @user.status.eql?(2) 
      @user.update_attributes(status: 1)
      redirect_to  admin_users_path,notice: "User's account activated successfully."
   elsif @user.status.eql?(1)
      @user.update_attributes(status: 2)
      redirect_to  admin_users_path, notice: "User's account blocked successfully."
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
