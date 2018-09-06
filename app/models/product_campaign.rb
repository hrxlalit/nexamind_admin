class ProductCampaign
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  belongs_to :product
  belongs_to :campaign
end
