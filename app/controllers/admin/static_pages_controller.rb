require 'will_paginate/array'
class Admin::StaticPagesController < ApplicationController
    before_action :require_admin_user, except: [:install_meta_mask]
    before_action :find_content, except: [:new, :create, :index]

    def index
      @static_pages = StaticPage.all.order('created_at asc')
    end

    def new
      @static_page = StaticPage.new
    end

    def create
      @static_page = StaticPage.new(static_page_params)
      if @static_page.save
        redirect_to admin_static_pages_path, notice: 'Static Content created Successfully.'
      else
        flash[:error] = @static_page.errors.full_messages.first
        render :new
      end
    end

    def edit
    end

    def update
      if @static_page.update_attributes(static_page_params)
        redirect_to admin_static_pages_path, notice: 'Static Content updated Successfully.'
      else
        flash[:error] = @static_page.errors.full_messages.first
        render :edit
      end
    end

    def show
    end

    def destroy
      if @static_page.destroy
        redirect_to admin_static_pages_path, notice: 'Static Content deleted Successfully.'
      else
        flash[:error] = @static_page.errors.full_messages.first
        render :edit
      end
    end

    private
    def find_content
      @static_page = StaticPage.find_by(id: params[:id])
      redirect_to admin_static_pages_path unless @static_page
    end
    def static_page_params
      params.require(:static_page).permit(:title,:description)
    end
end
