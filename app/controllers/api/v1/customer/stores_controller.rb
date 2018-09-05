class Api::V1::Customer::StoresController < ApplicationController
	before_action :find_user

	def index
		store_name = Regexp.new(".*#{params[:search]}.*","i")
		location = eval(params[:coordinates])
		if params[:search].present?
			@stores = Store.where(store_type: params[:type]).any_of({:name => store_name}) 
		else
			@stores = Store.where(store_type: params[:type])
		end
		@stores = @stores.geo_near(location).max_distance(10)
		@stores = @stores.map{|x| x.attributes.merge(rating: (x.ratings.pluck(:rate).map(&:to_i).sum > 0) ? ((x.ratings.pluck(:rate).map(&:to_i).sum.to_f)/(x.ratings.count)) : 0, is_fav: (x.fav_stores.find_by(user_id: @current_user.id).eql?(nil) ? false : true), camaign: x.campaigns.try(:last), image: (x.images.first.try(:file_url) if x.images.first.present?))}
		return render :json =>  {responseCode: 200, responseMessage: "Stored fetched successfully.", stores: @stores}
	end

	def add_fav
    	@fav_store = FavStore.find_by(store_id: params[:store_id], user_id: @current_user.id)
    	if @fav_store.present? && @fav_store.is_liked.eql?(true)
    		@fav_store.update(is_liked: false)
    	elsif @fav_store.present? && @fav_store.is_liked.eql?(false)
    		@fav_store.update(is_liked: true)
    	else
    		@fav_store = FavProduct.create(store_id: params[:store_id], user_id: @current_user.id)
    	end
    	return render :json =>  {responseCode: 200, responseMessage: "Store favorite status updated successfully.", fav_store: @fav_store}	
    end
end