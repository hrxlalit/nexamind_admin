require 'will_paginate/array'
class Admin::CampaignsController < ApplicationController
	before_action :require_admin_user
	before_action :find_content, except: [:new, :create, :index]

	def index
		@campaigns = Campaign.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@campaign = Campaign.new
	end

	def create
		@campaign = Campaign.new(campaign_params)
		if @campaign.save
			redirect_to admin_campaigns_path, notice: 'Campaign created Successfully.'
		else
			flash[:error] = @campaign.errors.full_messages.first
			render :new
		end
	end

	def edit
	end

	def update
		if @campaign.update_attributes(campaign_params)
			redirect_to admin_campaigns_path, notice: 'Campaign updated Successfully.'
		else
			flash[:error] = @campaign.errors.full_messages.first
			render :edit
		end
	end

	def show
	end

	def destroy
		if @campaign.destroy
			redirect_to admin_campaigns_path, notice: 'Campaign deleted Successfully.'
		else
			flash[:error] = @campaign.errors.full_messages.first
			render :edit
		end
	end

	private
	def find_content
		@campaign = Campaign.find_by(id: params[:id])
		redirect_to admin_campaigns_path unless @campaign
	end
	def campaign_params
		params.require(:campaign).permit(:name,:start_date,:end_date,:quantity,:discount)
	end
end
