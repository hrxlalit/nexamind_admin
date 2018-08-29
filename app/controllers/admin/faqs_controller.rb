require 'will_paginate/array'
class Admin::FaqsController <  Admin::BaseController
	before_action :require_admin_user
	before_action :find_content, except: [:new, :create, :index]

	def index
		@faqs = Faq.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	end

	def new
		@faq = Faq.new
	end

	def create
		@faq = Faq.new(faq_params)
		if @faq.save
			redirect_to admin_faqs_path, notice: 'Static Content created Successfully.'
		else
			flash[:error] = @faq.errors.full_messages.first
			render :new
		end
	end

	def edit
	end

	def update
		if @faq.update_attributes(faq_params)
			redirect_to admin_faqs_path, notice: 'Static Content updated Successfully.'
		else
			flash[:error] = @faq.errors.full_messages.first
			render :edit
		end
	end

	def show
	end

	def destroy
		if @faq.destroy
			redirect_to admin_faqs_path, notice: 'Static Content deleted Successfully.'
		else
			flash[:error] = @faq.errors.full_messages.first
			render :edit
		end
	end

	private
	def find_content
		@faq = Faq.find_by(id: params[:id])
		redirect_to admin_faqs_path unless @faq
	end
	def faq_params
		params.require(:faq).permit(:question,:answer)
	end
end
