require 'will_paginate/array'
class Admin::StoresController < ApplicationController
  before_action :require_admin_user
  before_action :find_store, except: [:index, :vendor_list]

  def index
    if params[:search].present? && params[:status].present?
      @search = Store.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")}).and({status: params[:status]})
      @stores = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif params[:status].present? && params[:status] != ""
      @search = Store.where({status: params[:status]})
      @stores = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    elsif params[:search].present? && params[:search] != ""
      @search = Store.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")})
      @stores = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      @stores = Store.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
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
