require 'will_paginate/array'
class Admin::TokensController < ApplicationController
	before_action :require_admin_user
	before_action :find_find, except: [:new, :create, :index]

	# def index
	# 	@tokens = Token.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	# end

	# def new
	# 	@token = Token.new
	# end

	# def create
	# 	@token = Token.new(token_params)
	# 	if @token.save
	# 		redirect_to admin_tokens_path, notice: 'Static Content created Successfully.'
	# 	else
	# 		flash[:error] = @token.errors.full_messages.first
	# 		render :new
	# 	end
	# end

	def edit
	end

	def update
		if @token.update_attributes(token_params)
			redirect_to admin_tokens_path, notice: 'Token rate updated Successfully.'
		else
			flash[:error] = @token.errors.full_messages.first
			render :edit
		end
	end

	def show
	end

	# def destroy
	# 	if @token.destroy
	# 		redirect_to admin_tokens_path, notice: 'Static Content deleted Successfully.'
	# 	else
	# 		flash[:error] = @token.errors.full_messages.first
	# 		render :edit
	# 	end
	# end

	private
	def find_content
		@token = Token.find_by(id: params[:id])
		redirect_to admin_tokens_path unless @token
	end
	def token_params
		params.require(:token).permit(:per_token_price,:adding_product_price)
	end
end
