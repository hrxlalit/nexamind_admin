require 'will_paginate/array'
class Admin::StoresController < ApplicationController
  before_action :require_admin_user
  before_action :find_store, except: [:index, :vendor_list]

  def index
    @search = Store.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")},{status: Regexp.new(".*#{params[:status]}.*","i")},{address: Regexp.new(".*#{params[:address]}.*","i")})
    @stores = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end

  def store_status
   if @store.status.eql?(2) 
      @store.update_attributes(status: 1)
      redirect_to  admin_stores_path,notice: "User's account activated successfully."
   elsif @store.status.eql?(1) 
      @store.update_attributes(status: 2)
      redirect_to  admin_stores_path, notice: "User's account blocked successfully."
   end
  end

  def edit
  end

  def update
    if @store.update_attributes(store_params)
			redirect_to admin_stores_path, notice: 'User updated Successfully.'
		else
      flash[:error] = @store.errors.full_messages.first
			render :edit
		end
  end

  def show
    
  end

  def destroy
    if @store.destroy
      redirect_to  admin_stores_path
    else
      flash[:error] = @store.errors.full_messages.first
      redirect_to  admin_stores_path
    end
  end


  private
  def find_store
    @store = Store.find_by(id: params[:id])
    redirect_to admin_stores_path unless @store
  end

  def store_params
		params.require(:store).permit(:email,:password,:name,:mobile,:address,:status,:gender, :country, :city, :code)
	end
end
