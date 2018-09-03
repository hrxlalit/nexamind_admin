class Api::V1::Customer::ProductsController < ApplicationController
	before_action :find_user

	def index
		product_name = Regexp.new(".*#{params[:search]}.*","i")
		@products = Store.find_by(id: params[:id]).products		
		@products = @products.any_of({:name => product_name}) if params[:search].present?
		@products = @products.map{|x| x.attributes.merge(rating: (x.product_ratings.pluck(:rate).map(&:to_i).sum > 0) ? ((x.product_ratings.pluck(:rate).map(&:to_i).sum.to_f)/(x.product_ratings.count)) : 0, is_fav: (x.fav_products.find_by(user_id: @current_user.id).eql?(nil) ? false : true), image: (x.images.first.try(:file_url) if x.images.first.present?))}
		return render :json =>  {responseCode: 200, responseMessage: "Products fetched successfully.", products: @products}
    end
end
# 5b87e98f4dfa6f3bc72f5edf