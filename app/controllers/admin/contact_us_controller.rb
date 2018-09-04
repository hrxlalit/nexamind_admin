require 'will_paginate/array'
class Admin::ContactUsController < ApplicationController
	before_action :require_admin_user
	before_action :find_content, except: [:index]

	def index
		@contacts = ContactU.any_of({title: Regexp.new(".*#{params[:search]}.*","i")}).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	end


	def show
	end

	private
	def find_content
		@contact = ContactU.find_by(id: params[:id])
		redirect_to admin_contacts_path unless @contact
	end	
end
