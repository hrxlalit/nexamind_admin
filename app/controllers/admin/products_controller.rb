require 'will_paginate/array'
class Admin::ProductsController < ApplicationController
  before_action :require_admin_user
  before_action :find_product, except: [:index, :vendor_list]

  def index
    @search = Product.any_of({name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")},{status: Regexp.new(".*#{params[:status]}.*","i")},{gender: Regexp.new(".*#{params[:gender]}.*","i")})
    @products = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end

  def product_status
   if @product.status.eql?(2) 
      @product.update_attributes(status: 1)
      redirect_to  admin_products_path,notice: "Product activated successfully."
   elsif @product.status.eql?(1) 
      @product.update_attributes(status: 2)
      redirect_to  admin_products_path, notice: "Product blocked successfully."
   end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
			redirect_to admin_products_path, notice: 'User updated Successfully.'
		else
      flash[:error] = @product.errors.full_messages.first
			render :edit
		end
  end

  def show
    
  end

  def destroy
    if @product.destroy
      redirect_to  admin_products_path
    else
      flash[:error] = @product.errors.full_messages.first
      redirect_to  admin_products_path
    end
  end


  private
  def find_product
    @product = Product.find_by(id: params[:id])
    redirect_to admin_products_path unless @product
  end

  def product_params
		params.require(:product).permit(:email,:password,:name,:mobile,:address,:status,:gender, :country, :city, :code)
	end
end
