class Api::V1::Customer::NotificationsController < ApplicationController
  require 'will_paginate/array'
  before_action :find_user

  def notification_list
  	@notification = Notification.where(user_id: @current_user.id).order('created_at DESC')
  	all_notification = @notification.paginate(:page => params[:page], :per_page => 10)
    render :json => { :responseCode => 200,
                      :responseMessage => "Notification list fetched successfully.",
                      :notifications => all_notification,
                       pagination: { page_no: all_notification.current_page, per_page: 10, max_page_size: all_notification.total_pages, total_records: all_notification.total_entries }
                    }

  end

  def destroy
  	Notification.where(id: params[:id].to_i, user_id: @current_user.id).destroy_all
  	render :json =>  {:responseCode => 200, :responseMessage => "Notification deleted successfully." }
  end	
end
