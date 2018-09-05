class Api::V1::Customer::ProductsController < ApplicationController
  before_action :find_user

  def product_list
  	@store = Store.and({:id => params[:id]}, {:store_type => params[:store_type]}).first
  	return render_message 402, "Store doesn't exists." unless @store.present?
  	@products = @store.products
  	if params[:search].present?
	  product_name = Regexp.new(".*#{params[:search]}.*","i")
	  @products = @products.any_of({:name => product_name}) if params[:search].present?
	elsif params[:category].present?
	  @products = @products.and({:price.gte => params[:min]}, {:price.lte => params[:max]}) if params[:min].present? && params[:max].present?
	  if @store.store_type == 1
	  	@products = @products.where(:category => params[:category])	
	  elsif @store.store_type == 0
	  	@products = @products.any_of({:category => params[:category]}, {:subcategory => params[:subcategory]}, {:subcategory => params[:subcategory]}, {:availed_size => params[:availed_size]}, {:availed_color => params[:availed_color]}) 
	  end
	end
	@products = @products.map{|x| x.attributes.merge(rating: (x.product_ratings.pluck(:rate).map(&:to_i).sum > 0) ? ((x.product_ratings.pluck(:rate).map(&:to_i).sum.to_f)/(x.product_ratings.count)) : 0, is_fav: (x.fav_products.find_by(user_id: @current_user.id).eql?(nil) ? false : true), image: (x.images.try(:first).try(:file_url) if x.images.try(:first).present?))}
	return render :json =>  {responseCode: 200, responseMessage: "Products fetched successfully.", products: @products}
  end

  def product_detail
    @product = Product.find_by(id: params[:product_id])
    return render_message 402, "Product doesn't exists." unless @product.present?
    product_hash = {}
    product_hash[:product] = @product
    product_hash[:image] = @product.try(:images)
    render :json => { :responseCode => 200,
                    :responseMessage => "Product fetched successfully.",
                    :products => product_hash
                   }
  end

  def product_review
    @product = Product.find_by(id: params[:product_id])
    return render_message 402, "Product doesn't exists." unless @product.present?
    product_arr = []
    @product.product_ratings.each do |product|
      product_arr << product.as_json.merge("user" => product.user.as_json.slice("_id", "email", "name").merge("image" => product.user.try(:image).try(:file_url)))
    end
    render :json => { :responseCode => 200,
                    :responseMessage => "Reviews fetched successfully.",
                    :reviews => product_arr
                   }
  end

    def write_review
	    @product = Product.find_by(id: params[:product_id])
	    return render_message 402, "Product doesn't exists." unless @product.present?
	    @review = @product.product_ratings.new(rate: params[:rate], review: params[:review], user_id: @current_user)
	    if @review.save
	      render :json => { :responseCode => 200,
	                    :responseMessage => "Review created successfully.",
	                    :reviews => @review
	                   }
	    else
	      render_message 402, "Review not created."	
	    end
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
