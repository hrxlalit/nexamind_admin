class Campaign
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :name, type: String
  field :start_date, type: String
  field :end_date, type: String
  field :quantity, type: String
  field :discount, type: String
   
  belongs_to :store
  has_many :product_campaigns, dependent: :destroy
  accepts_nested_attributes_for :product_campaigns, :allow_destroy => true, :reject_if =>:all_blank
  
  def products
    Product.in(id: product_campaigns.pluck(:product_id))
  end
end
