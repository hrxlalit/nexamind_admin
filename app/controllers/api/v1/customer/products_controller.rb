class Api::V1::Customer::ProductsController < ApplicationController
	before_action :find_user

	def index
		product_name = Regexp.new(".*#{params[:search]}.*","i")
		@products = Store.find_by(id: params[:id]).products		
		@products = @products.any_of({:name => product_name}) if params[:search].present?
		@products = @products.map{|x| x.attributes.merge(rating: (x.product_ratings.pluck(:rate).map(&:to_i).sum > 0) ? ((x.product_ratings.pluck(:rate).map(&:to_i).sum.to_f)/(x.product_ratings.count)) : 0, is_fav: (x.fav_products.find_by(user_id: @current_user.id).eql?(nil) ? false : true), image: (x.images.first.try(:file_url) if x.images.first.present?))}
		return render :json =>  {responseCode: 200, responseMessage: "Products fetched successfully.", products: @products}
    end

    def add_fav
    	@fav_product = FavProduct.find_by(product_id: params[:product_id], user_id: @current_user.id)
    	if @fav_product.present? && @fav_product.is_liked.eql?(true)
    		@fav_product.update(is_liked: false)
    	elsif @fav_product.present? && @fav_product.is_liked.eql?(false)
    		@fav_product.update(is_liked: true)
    	else
    		@fav_product = FavProduct.create(product_id: params[:product_id], user_id: @current_user.id)
    	end
    	return render :json =>  {responseCode: 200, responseMessage: "Product favorite status updated successfully.", fav_product: @fav_product}	
    end
end
