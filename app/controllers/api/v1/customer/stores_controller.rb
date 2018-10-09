class Api::V1::Customer::StoresController < ApplicationController
	before_action :find_user

  def index
    store_name = Regexp.new(".*#{params[:search]}.*","i")
	location = eval(params[:coordinates])
	if params[:search].present?
	  @stores = Store.where(store_type: params[:store_type]).any_of({:name => store_name}) 
	else
	  @stores = Store.where(store_type: params[:store_type])
	end
	@stores = @stores.geo_near(location).max_distance(10)
	@stores = @stores.map{|x| x.attributes.merge(rating: (x.ratings.pluck(:rate).map(&:to_i).sum > 0) ? ((x.ratings.pluck(:rate).map(&:to_i).sum.to_f)/(x.ratings.count)) : 0, is_fav: (x.fav_stores.find_by(user_id: @current_user.id).eql?(nil) ? false : true), camaign: x.campaigns.try(:last), image: (x.images.first.try(:file_url) if x.images.first.present?))}
	return render :json =>  {responseCode: 200, responseMessage: "Stored fetched successfully.", stores: @stores}
  end

  def store_detail
  	@store = Store.and({:id => params[:id]}, {:store_type => params[:store_type]}).first
  	return render_message 402, "Store doesn't exists." unless @store.present?
  	rating = @store.products.map{|prod| prod.product_ratings.pluck(:rate)}.try(:flatten).try(:sum)/@store.products.map{|prod| prod.product_ratings.size}.try(:flatten).try(:sum)
    @image = @store.try(:images).map{|x| x.try(:file_url)}
    @select = @store.as_json.merge("image" => @image, "service_timing" => @store.try(:service_timings), "rating" => rating).except("otp", "otp_gen_time", "unique_id", "password_digest")
    render json: {responseCode: 200, responseMessage: "Store fetched successfully.",user: @select}
  end

  def add_fav
	@store = Store.find_by({:id => params[:id]})
  	return render_message 402, "Store doesn't exists." unless @store.present?
	@fav_store = @store.fav_stores.find_or_create_by(store_id: params[:id], user_id: @current_user.id)
	if @fav_store.update(is_liked: params[:is_liked])
	  render :json => { :responseCode => 200,
	                  :responseMessage => "Store favorite status updated successfully.",
	                  :fav_store => @fav_store
	                 }
	else
	  render_message 402, "Store favorite status not updated."
    end 
  end
end