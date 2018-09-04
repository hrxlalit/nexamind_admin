class Api::V1::Storeapi::ProductsController < ApplicationController
  require 'will_paginate/array'
  before_action :find_store
  include ProductsConcern

  def create
  	@product = @current_store.products.new(product_params)
  	if @product.save
  	  product_hash = {}
  	  product_hash[:product] = @product
  	  product_img = @product.images.reload if params[:images_attributes].present?
      product_hash[:images_attributes] = product_img
  	  render :json => { :responseCode => 200,
  	                  :responseMessage => "Product created successfully.",
  	                  :products => product_hash
  	                 }
  	else
      return render_message 402, "Product not created."
    end           
  end	

  def product_list
    @products = all_product_list(params, @current_store)
    @merge = []
    @products.each do |similar|
      @merge << similar.as_json.merge("images_attributes" => similar.try(:images))
    end
    all_product = @merge.paginate(:page => params[:page], :per_page => 10)
    render :json => { :responseCode => 200,
                      :responseMessage => "Product list fetched successfully.",
                      :products => all_product,
                       pagination: { page_no: all_product.current_page, per_page: 10, max_page_size: all_product.total_pages, total_records: all_product.total_entries }
                    }
  end

  def product_update
    @product = @current_store.products.find_by(id: params[:product_id])
    return render_message 402, "Product doesn't exists." unless @product.present?
    if @product.update_attributes(product_params)
      product_hash = {}
      product_hash[:product] = @product
      product_img = @product.images.reload if params[:images_attributes].present?
      product_hash[:images_attributes] = product_img
      render :json => { :responseCode => 200,
                      :responseMessage => "Product updated successfully.",
                      :products => product_hash
                     }
    else
      return render_message 402, "Product not updated."
    end            
  end

  def product_detail
    @product = @current_store.products.find_by(id: params[:product_id])
    return render_message 402, "Product doesn't exists." unless @product.present?
    product_hash = {}
    product_hash[:product] = @product
    product_hash[:images_attributes] = @product.try(:images)
    render :json => { :responseCode => 200,
                    :responseMessage => "Product fetched successfully.",
                    :products => product_hash
                   }
  end

  def product_review
    @product = @current_store.products.find_by(id: params[:product_id])
    return render_message 402, "Product doesn't exists." unless @product.present?
    product_arr = []
    @product.product_ratings.each do |product|
      product_arr << product.as_json.merge("user" => product.user.as_json.slice("_id", "email", "name").merge("image" => product.user.try(:image).try(:file_url)))
    end
    render :json => { :responseCode => 200,
                    :responseMessage => "Reviews fetched successfully.",
                    :reviews => product_arr
                   }
  end

  private

  def product_params
    params.permit(:name, :cost, :price, :quantity, :sku, :description, :category, :subcategory, :latitude, :longitude, :description, availed_size: [], availed_color: [],
    images_attributes: [:id, :file, :_destroy])
  end
end
