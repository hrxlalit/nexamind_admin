class Api::V1::Storeapi::CampaignsController < ApplicationController
  require 'will_paginate/array'
  before_action :find_store
  include ProductsConcern

  def create
  	@campaign = @current_store.campaigns.new(campaign_params)
  	if @campaign.save
  	  render :json => { :responseCode => 200,
  	                  :responseMessage => "Campaign created successfully.",
  	                  :campaigns => @campaign.as_json.merge("product_campaign" => @campaign.product_campaigns)
  	                 }
  	else
      return render_message 402, "Campaign not created."
    end           
  end

  def edit_campaign
  	@campaign = @current_store.campaigns.find_by({:id => params[:campaign_id]})
	return render_message 402, "Campaign doesn't exists." unless @campaign.present?
  	if @campaign.update_attributes(campaign_params)
  	  render :json => { :responseCode => 200,
  	                  :responseMessage => "Campaign updated successfully.",
  	                  :campaigns => @campaign.as_json.merge("product_campaign" => @campaign.product_campaigns)
  	                 }
  	else
      return render_message 402, "Campaign not updated."
    end           
  end

  def list_campaign
  	@campaign = all_campaign_list(params, @current_store)
  	all_campaign = @campaign.paginate(:page => params[:page], :per_page => 10)
    render :json => { :responseCode => 200,
                      :responseMessage => "Campaign list fetched successfully.",
                      :products => all_campaign,
                       pagination: { page_no: all_campaign.current_page, per_page: 10, max_page_size: all_campaign.total_pages, total_records: all_campaign.total_entries }
                    }
  end

  def product_list_name
  	@products = @current_store.products.map{|x| x.as_json.slice("_id", "name")}
    render :json => { :responseCode => 200,
                      :responseMessage => "Product list fetched successfully.",
                      :products => @products,
                    }
  end

  def detail_campaign
  	@campaign = @current_store.campaigns.find_by({:id => params[:campaign_id]})
	  return render_message 402, "Campaign doesn't exists." unless @campaign.present?
  	render :json => { :responseCode => 200,
  	                  :responseMessage => "Campaign fetched successfully.",
  	                  :campaigns => @campaign.as_json.merge("product_campaign" => Product.where(id: { '$in': @campaign.product_campaigns.pluck(:product_id)}).map{|x| x.as_json.slice("_id", "name")})
  	                 }           
  end

  private

  def campaign_params
    params.permit(:name, :start_date, :end_date, :quantity, :discount, product_campaigns_attributes: [:_id, :product_id, :_destroy])
  end	
end
