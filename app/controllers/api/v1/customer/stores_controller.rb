class Api::V1::Customer::StoresController < ApplicationController
	before_action :find_user

	def index
	    @search = Store.any_of({name: Regexp.new(".*#{params[:name]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{mobile: Regexp.new(".*#{params[:search]}.*","i")},{status: Regexp.new(".*#{params[:status]}.*","i")},{gender: Regexp.new(".*#{params[:gender]}.*","i")})
	    @users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
end