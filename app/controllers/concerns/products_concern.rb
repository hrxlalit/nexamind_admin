module ProductsConcern
  def all_product_list(params={}, current_store)
	if (params[:name].present?)
	  search_var = Regexp.new(".*#{params[:name]}.*","i")
	  current_store.products.where(name: search_var)
	else
	  current_store.products
	end
  end
end
