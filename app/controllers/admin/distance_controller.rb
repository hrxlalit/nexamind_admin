require 'will_paginate/array'
class Admin::DistanceController < ApplicationController
	before_action :require_admin_user
   	def index
   	end

   	def save_distance
   		
   		if current_admin_user.distance_setting.present?
   		@admin_user = DistanceSetting.find_by(admin_user_id: current_admin_user.id )
   		@admin_user.update(distance_params)
   		redirect_to admin_distance_index_path

   		else
   		@distance = DistanceSetting.new(distance_params)
   		@distance.admin_user_id = current_admin_user.id
   		 if @distance.save
          redirect_to admin_distance_index_path
          flash[:notice] = 'Distance updated Successfully.'
         else
          render admin_distance_index_path
          flash[:notice] = 'Please try again.'
          end

   		end 
   	end

    private
   	def distance_params
      params.require(:distance).permit(:distance_range_for_vaildator_of_product_or_store, :distance_range_for_customer_to_view_store)
    end
end
