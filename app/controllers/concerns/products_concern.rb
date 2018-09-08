module ProductsConcern
  extend ActiveSupport::Concern

  def all_product_list(params={}, current_store)
	if (params[:name].present?)
	  search_var = Regexp.new(".*#{params[:name]}.*","i")
	  current_store.products.where(name: search_var)
    else
	  current_store.products
	end
  end

  def all_campaign_list(params={}, current_store)
	if (params[:name].present?)
	  search_var = Regexp.new(".*#{params[:name]}.*","i")
	  current_store.campaigns.where(name: search_var)
    else
	  current_store.campaigns
	end
  end
end
