class Api::V1::Storeapi::CampaignsController < ApplicationController
  require 'will_paginate/array'
  before_action :find_store
  extend ProductsConcern

  def create
  	@product = @current_store.campaigns.new(campaign_params)
  	if @product.save
  	  product_hash = {}
  	  product_hash[:product] = @product
  	  product_img = @product.images.reload
      product_hash[:images_attributes] = product_img
  	  render :json => { :responseCode => 200,
  	                  :responseMessage => "Product created successfully.",
  	                  :products => product_hash
  	                 }
  	else
      return render_message 402, "Product not created."
    end           
  end

  private

  def campaign_params
    params.permit(:name, :start_date, :end_date, :quantity, :discount, :product_id)
  end	
end
