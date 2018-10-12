require 'will_paginate/array'
class Admin::UsersController < ApplicationController
  before_action :require_admin_user
  before_action :find_user, except: [:index, :vendor_list]

    def index
      # if params[:search].present?
      #   if params[:gender].present? && params[:status].present?
      #     @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(gender: params[:gender],status: params[:status])       
      #   elsif params[:gender].present?
      #     @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(gender: params[:gender],status: (0..1))       
      #   elsif params[:status].present?
      #     @search = User.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(status: params[:status])       
      #   end 
      # elsif params[:gender].present?
      #     if params[:status].present?
      #       @search = User.where(status: params[:status], gender: params[:gender])
      #     end
      # elsif params[:status].present?
      #       @search = User.where(status: params[:status])
      # else      
      #   @search = User.where(status: (0..1))     
      # end     
        @users = User.where(status: (0..1)).order("created_at desc").paginate(:page => params[:page], :per_page => 10)   
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

  def user_approve
    @user.update_attributes(admin_approved: 1) if params[:admin_approved] == "1"
    @user.update_attributes(admin_approved: 0) if params[:admin_approved] == "0"
    redirect_to request.referer
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
