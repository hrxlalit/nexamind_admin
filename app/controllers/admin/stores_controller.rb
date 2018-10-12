require 'will_paginate/array'
class Admin::StoresController < ApplicationController
  before_action :require_admin_user
  before_action :find_store, except: [:index, :vendor_list, :new, :create, :import, :export]

  def index
    if params[:search].present? && params[:status].present?
      @search = Store.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(status: params[:status])
    elsif params[:search].present? && !params[:status].present? 
      @search = Store.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")}).where(status: (0..1))
    elsif !params[:search].present? && params[:status].present? 
      @search = Store.where(status: params[:status])
    else
      @search = Store.where(status: (0..1))
    end          
    @stores = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @store = Store.new
  end

  def create
    @store  = Store.new(store_params)
    if @store.save
       flash[:notice] = "Store created successfully."
       redirect_to admin_stores_path 
    else   
       flash[:alert] = @store.errors.messages
       redirect_to request.referer

    end 
  end

  def store_status
   if @store.status.eql?(0) 
      @store.update_attributes(status: 1)
      redirect_to  admin_stores_path,notice: "Service Provider activated successfully."
   elsif @store.status.eql?(1) 
      @store.update_attributes(status: 0)
      redirect_to  admin_stores_path, notice: "Service Provider blocked successfully."
   end
  end

  def store_approve
    @store.update_attributes(admin_approved: 1) if params[:admin_approved] == "1"
    @store.update_attributes(admin_approved: 0) if params[:admin_approved] == "0"
    redirect_to request.referer
  end

  def edit
  end

  def update
    if @store.update_attributes(store_params)
      redirect_to admin_stores_path, notice: 'Service Provider updated Successfully.'
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

  def import
    Store.import(params[:file])
    redirect_to request.referer, notice: "Service Provider List imported."
  end

  def export
    @store = Store.all
    respond_to do |format|
      format.html
      format.csv{ send_data @store.export,filename: "store-dummy-csv.csv"}
    end
  end


  private
  def find_store
    @store = Store.find_by(id: params[:id])
    redirect_to admin_stores_path unless @store
  end

  def store_params
		params.require(:store).permit(:email,:password,:name,:mobile,:address,:status,:gender, :country, :city, :code, :website, :description, :location, :store_type)
	end
end
