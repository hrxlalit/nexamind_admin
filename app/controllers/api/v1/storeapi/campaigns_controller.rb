class Api::V1::Storeapi::CampaignsController < ApplicationController
  require 'will_paginate/array'
  before_action :find_store
  extend ProductsConcern

  def create
  	@campaign = @current_store.campaigns.new(campaign_params)
  	if @product.save
  	  if params[:product_id].present?	
  	  	campaign_arr = []
  		params[:product_id].each do |prod_camp|
  		 campaign_arr << ProductCampaign.create(product_id: prod_camp, campaign_id: @campaign.id)
  		end
  	  end
  	  render :json => { :responseCode => 200,
  	                  :responseMessage => "Campaign created successfully.",
  	                  :campaign => @campaign.as_json.merge("product_campaign" => campaign_arr)
  	                 }
  	else
      return render_message 402, "Product not created."
    end           
  end

  def product_list_name
  	@products = @current_store.products.map{|x| x.as_json.slice("_id", "name")}
    render :json => { :responseCode => 200,
                      :responseMessage => "Product list fetched successfully.",
                      :products => @products,
                    }
  end

  private

  def campaign_params
    params.permit(:name, :start_date, :end_date, :quantity, :discount, tag_friends_attributes: [:id, :product_id, :_destroy])
  end	
end
